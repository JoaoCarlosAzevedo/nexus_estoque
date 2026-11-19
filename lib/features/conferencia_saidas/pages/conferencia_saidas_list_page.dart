import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';
import 'package:nexus_estoque/core/utils/datetime_formatter.dart';
import 'package:nexus_estoque/features/etiqueta_nf_saida/data/model/etiqueta_nf_saida_status_model.dart';
import 'package:nexus_estoque/features/etiqueta_nf_saida/data/repositories/etiqueta_nf_saida_repository.dart';
import 'package:nexus_estoque/features/outflow_doc_check/pages/outflow_doc_page/outflow_doc_page.dart';

import '../conferencia_saida_status.dart';

class ConferenciaSaidasListPage extends ConsumerStatefulWidget {
  const ConferenciaSaidasListPage({super.key});

  @override
  ConsumerState<ConferenciaSaidasListPage> createState() =>
      _ConferenciaSaidasListPageState();
}

class _ConferenciaSaidasListPageState
    extends ConsumerState<ConferenciaSaidasListPage> {
  late String dateIni;
  late String dateEnd;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    dateIni = datetimeToYYYYMMDD(DateTime.now());
    dateEnd = datetimeToYYYYMMDD(DateTime.now());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _rangeKey => '$dateIni|$dateEnd';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(etiquetaNfSaidaStatusProvider(_rangeKey));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('NFs Saida'),
            Text(
              '${yyyymmddToDate(dateIni)} - ${yyyymmddToDate(dateEnd)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () =>
                ref.invalidate(etiquetaNfSaidaStatusProvider(_rangeKey)),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () => _pickDateRange(context),
            icon: const Icon(Icons.calendar_month),
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
                      onPressed: () => ref
                          .invalidate(etiquetaNfSaidaStatusProvider(_rangeKey)),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          data: (list) {
            if (list.isEmpty) {
              return const Center(
                child: Text('Nenhuma NF encontrada para o período.'),
              );
            }

            final query = _searchQuery.trim().toLowerCase();
            final filtered = query.isEmpty
                ? list
                : list.where((nf) {
                    return nf.notaFiscal.toLowerCase().contains(query) ||
                        nf.nomeCliente.toLowerCase().contains(query);
                  }).toList();

            if (filtered.isEmpty) {
              return _searchAndMessage(
                message: 'Nenhuma NF encontrada.',
                total: list.length,
                shown: 0,
              );
            }

            return Column(
              children: [
                _searchField(total: list.length, shown: filtered.length),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    children: [
                      for (final status in ConferenciaSaidaStatus.values)
                        ..._section(
                          context,
                          status,
                          filtered
                              .where((nf) => nf.statusConferencia == status)
                              .toList(),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _searchAndMessage({
    required String message,
    required int total,
    required int shown,
  }) {
    return Column(
      children: [
        _searchField(total: total, shown: shown),
        Expanded(child: Center(child: Text(message))),
      ],
    );
  }

  Widget _searchField({required int total, required int shown}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Buscar por NF ou cliente',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          if (_searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 6, bottom: 4),
              child: Text(
                '$shown de $total NFs',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _section(
    BuildContext context,
    ConferenciaSaidaStatus status,
    List<EtiquetaNfSaidaStatus> notas,
  ) {
    if (notas.isEmpty) return const [];

    final color = _statusColor(status);
    final String label;
    switch (status) {
      case ConferenciaSaidaStatus.pendente:
        label = 'Pendente';
        break;
      case ConferenciaSaidaStatus.parcial:
        label = 'Parcial';
        break;
      case ConferenciaSaidaStatus.conferida:
        label = 'Conferida';
        break;
    }

    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
        child: Text(
          '$label (${notas.length})',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      for (final nf in notas)
        _NfCard(
          nf: nf,
          onTap: () => _openCheck(nf),
        ),
    ];
  }

  Future<void> _openCheck(EtiquetaNfSaidaStatus nf) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OutFlowDocCheckPage(chave: nf.chaveNFe),
      ),
    );
    if (!mounted) return;
    ref.invalidate(etiquetaNfSaidaStatusProvider(_rangeKey));
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final themeData = Theme.of(context);
    final datePicked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now(),
      ),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: themeData.copyWith(
          datePickerTheme: const DatePickerThemeData(
            rangeSelectionBackgroundColor: AppColors.background,
          ),
          appBarTheme: themeData.appBarTheme.copyWith(
            backgroundColor: Colors.blue,
            iconTheme:
                themeData.appBarTheme.iconTheme!.copyWith(color: Colors.red),
          ),
          colorScheme: const ColorScheme.light(
            onPrimary: Colors.white,
            primary: Colors.grey,
          ),
        ),
        child: child!,
      ),
    );

    if (datePicked == null || !mounted) return;

    setState(() {
      dateIni = datetimeToYYYYMMDD(datePicked.start);
      dateEnd = datetimeToYYYYMMDD(datePicked.end);
    });
  }
}

class _NfCard extends StatelessWidget {
  const _NfCard({required this.nf, required this.onTap});

  final EtiquetaNfSaidaStatus nf;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _statusColor(nf.statusConferencia);
    final total = nf.produtos.length;
    final conferidos = nf.itensConferidos;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NF ${nf.notaFiscal} / ${nf.serie}',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nf.nomeCliente,
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$conferidos de $total ${total == 1 ? 'item' : 'itens'}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Chip(
                label: Text(
                  nf.statusLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                visualDensity: VisualDensity.compact,
                side: BorderSide(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _statusColor(ConferenciaSaidaStatus status) {
  switch (status) {
    case ConferenciaSaidaStatus.pendente:
      return Colors.orange.shade800;
    case ConferenciaSaidaStatus.parcial:
      return Colors.amber.shade900;
    case ConferenciaSaidaStatus.conferida:
      return Colors.green.shade700;
  }
}
