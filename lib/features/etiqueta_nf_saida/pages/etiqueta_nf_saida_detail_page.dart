import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/features/bluetooth_printer/bluetooth_printer.dart';
import '../../../core/services/bt_printer.dart';
import '../data/model/etiqueta_nf_saida_model.dart';
import '../data/repositories/etiqueta_nf_saida_repository.dart';

class EtiquetaNfSaidaDetailPage extends ConsumerWidget {
  const EtiquetaNfSaidaDetailPage({
    required this.chave,
    this.notaFiscal,
    this.serie,
    super.key,
  });

  final String chave;
  final String? notaFiscal;
  final String? serie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(etiquetaNfSaidaDetailProvider(chave));
    final headerTitle = notaFiscal != null && notaFiscal!.isNotEmpty
        ? 'Etiquetas NF $notaFiscal${serie != null && serie!.isNotEmpty ? ' / $serie' : ''}'
        : 'Etiquetas NF Saída';

    return Scaffold(
      appBar: AppBar(
        title: Text(headerTitle),
        actions: [
          IconButton(
            onPressed: () =>
                ref.invalidate(etiquetaNfSaidaDetailProvider(chave)),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: async.when(
          skipLoadingOnRefresh: false,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          ref.invalidate(etiquetaNfSaidaDetailProvider(chave)),
                      child: const Text("Tentar novamente"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          data: (data) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _NfHeaderCard(data: data),
                  const SizedBox(height: 8),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Etiquetas',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              '${data.etiquetas.length} / ${data.volumes}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: data.etiquetas.isEmpty
                                  ? null
                                  : () => _printAll(context, data.etiquetas),
                              icon: const FaIcon(
                                FontAwesomeIcons.print,
                                size: 16,
                              ),
                              label: const Text('Imprimir todas'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: data.etiquetas.isEmpty
                        ? const Center(
                            child: Text('Nenhuma etiqueta disponível.'),
                          )
                        : ListView.builder(
                            itemCount: data.etiquetas.length,
                            itemBuilder: (context, index) {
                              final e = data.etiquetas[index];
                              return _LabelCard(
                                etiqueta: e,
                                totalVolumes: data.volumes,
                                onPrint: () => _print(context, e),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _print(BuildContext context, EtiquetaItem etiqueta) async {
    final messenger = ScaffoldMessenger.of(context);
    final isPrinted = await BluetoothPrinter.printZPL(etiqueta.etiqueta);
    if (!context.mounted) return;
    if (isPrinted) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Etiqueta volume ${etiqueta.volume} enviada.'),
        ),
      );
    } else {
      await BluetoothPageModal.show(context);
    }
  }

  Future<void> _printAll(
    BuildContext context,
    List<EtiquetaItem> etiquetas,
  ) async {
    if (etiquetas.isEmpty) return;

    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Imprimir todas'),
        content: Text(
          'Deseja enviar ${etiquetas.length} ${etiquetas.length == 1 ? "etiqueta" : "etiquetas"} para a impressora?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Imprimir'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    final zpl = etiquetas.map((e) => e.etiqueta).join();
    final isPrinted = await BluetoothPrinter.printZPL(zpl);

    if (!context.mounted) return;
    if (isPrinted) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            '${etiquetas.length} ${etiquetas.length == 1 ? "etiqueta enviada" : "etiquetas enviadas"}.',
          ),
        ),
      );
    } else {
      await BluetoothPageModal.show(context);
    }
  }
}

class _NfHeaderCard extends StatelessWidget {
  const _NfHeaderCard({required this.data});

  final EtiquetaNfSaida data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'NF ${data.notaFiscal}',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Chip(
                  label: Text(
                    '${data.volumes} vol.',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const Divider(),
            _InfoRow(label: 'Cliente', value: data.cliente),
            _InfoRow(label: 'Endereço', value: data.endereco),
            _InfoRow(
              label: 'Bairro / Município / UF',
              value: [
                data.bairro,
                data.municipio,
                data.est,
              ].where((s) => s.isNotEmpty).join(' - '),
            ),
            _InfoRow(label: 'Pedido', value: data.pedido),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

class _LabelCard extends StatelessWidget {
  const _LabelCard({
    required this.etiqueta,
    required this.totalVolumes,
    required this.onPrint,
  });

  final EtiquetaItem etiqueta;
  final int totalVolumes;
  final VoidCallback onPrint;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            '${etiqueta.volume}',
            style:
                const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
        title: Text('Volume ${etiqueta.volume} / $totalVolumes'),
        subtitle: const Text('Etiqueta ZPL'),
        trailing: IconButton.filledTonal(
          iconSize: 28,
          color: Colors.green,
          onPressed: onPrint,
          icon: const FaIcon(
            FontAwesomeIcons.print,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
