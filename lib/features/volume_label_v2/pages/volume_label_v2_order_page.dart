import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/features/bluetooth_printer/bluetooth_printer.dart';
import '../../../core/services/bt_printer.dart';
import '../../../core/theme/app_colors.dart';
import '../../filter_tags_orders/data/model/filter_tag_load_order_model.dart';
import '../../filter_tags_orders/data/repositories/filter_tag_order_repository.dart';

class VolumeLabelV2OrderPage extends ConsumerWidget {
  final Orders order;

  const VolumeLabelV2OrderPage({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pedido: ${order.pedido}'),
            Text(
              order.nomeCliente,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título dos itens
              Text(
                'Etiquetas Emitidas',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),

              // Consumer para orderVolumesProvider
              Consumer(
                builder: (context, ref, child) {
                  final orderVolumesAsync =
                      ref.watch(orderVolumesProvider(order.pedido));

                  return orderVolumesAsync.when(
                    data: (orderData) {
                      if (orderData.itens.isEmpty) {
                        return const Expanded(
                          child: Center(
                            child: Text('Nenhum item encontrado'),
                          ),
                        );
                      }
                      return Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: orderData.itens.length,
                                itemBuilder: (context, index) {
                                  final item = orderData.itens[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: ExpansionTile(
                                      title: Text(
                                        item.descricao,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 4),
                                          Text('Código: ${item.codigo}'),
                                          Text('UM: ${item.um}'),
                                          const SizedBox(height: 8),
                                          if (item.codigobarras.isNotEmpty) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              'Código de Barras: ${item.codigobarras}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        ],
                                      ),
                                      children: [
                                        // Lista de volumes com ícone de impressão
                                        if (item.volumes.isNotEmpty) ...[
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Text(
                                              'Volumes:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          ...item.volumes.map((volume) =>
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 16.0,
                                                  vertical: 2.0,
                                                ),
                                                child: Card(
                                                  color: Colors.grey[50],
                                                  child: ListTile(
                                                    title: Text(
                                                        'Etiqueta ${volume.volume}/${volume.volumeMaximo}'),
                                                    trailing: IconButton(
                                                      onPressed: () {
                                                        _printVolume(
                                                            context, volume);
                                                      },
                                                      icon: const FaIcon(
                                                        FontAwesomeIcons.print,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                          const SizedBox(height: 8),
                                        ] else ...[
                                          const Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text(
                                              'Nenhum volume encontrado',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => const Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Carregando dados do pedido...'),
                          ],
                        ),
                      ),
                    ),
                    error: (error, stack) => Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.triangleExclamation,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Erro ao carregar dados',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              error.toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                ref.invalidate(
                                    orderVolumesProvider(order.pedido));
                              },
                              child: const Text('Tentar Novamente'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showItemDetails(BuildContext context, OrdersProduct item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.descricao),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Código:', item.codigo),
              _buildDetailRow('Item:', item.item),
              _buildDetailRow('Descrição:', item.descricao),
              _buildDetailRow('UM:', item.um),
              _buildDetailRow('Quantidade:', item.quantidade.toString()),
              _buildDetailRow('Etiquetas:', item.quantidaetiqueta.toString()),
              _buildDetailRow(
                  'Nova Quantidade:', item.novaQuantidade.toString()),
              _buildDetailRow('Carga:', item.carga),
              if (item.codigobarras.isNotEmpty)
                _buildDetailRow('Código de Barras:', item.codigobarras),
              if (item.codigobarras2.isNotEmpty)
                _buildDetailRow('Código de Barras 2:', item.codigobarras2),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _printVolume(BuildContext context, OrdersProductVolume volume) async {
    final isPrinted = await BluetoothPrinter.printZPL(volume.etiqueta);
    if (!isPrinted) {
      // ignore: use_build_context_synchronously
      BluetoothPageModal.show(context);
    }
  }
}
