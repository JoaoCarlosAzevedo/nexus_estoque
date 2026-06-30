import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';
import 'package:nexus_estoque/core/utils/datetime_formatter.dart';

import '../data/model/etiqueta_nf_saida_status_model.dart';
import '../data/repositories/etiqueta_nf_saida_repository.dart';
import 'etiqueta_nf_saida_detail_page.dart';

class EtiquetaNfSaidaListPage extends ConsumerStatefulWidget {
  const EtiquetaNfSaidaListPage({super.key});

  @override
  ConsumerState<EtiquetaNfSaidaListPage> createState() =>
      _EtiquetaNfSaidaListPageState();
}

class _EtiquetaNfSaidaListPageState
    extends ConsumerState<EtiquetaNfSaidaListPage> {
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
            const Text("Etiquetas NF Saída"),
            Text(
              "${yyyymmddToDate(dateIni)} - ${yyyymmddToDate(dateEnd)}",
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
                      child: const Text("Tentar novamente"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          data: (list) {
            if (list.isEmpty) {
              return const Center(
                child: Text("Nenhuma NF encontrada para o período."),
              );
            }

            final query = _searchQuery.trim().toLowerCase();
            final filtered = query.isEmpty
                ? list
                : list.where((nf) {
                    return nf.notaFiscal.toLowerCase().contains(query) ||
                        nf.nomeCliente.toLowerCase().contains(query) ||
                        nf.nomeTransp.toLowerCase().contains(query);
                  }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Buscar por NF, cliente ou transportadora',
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
                ),
                if (_searchQuery.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${filtered.length} de ${list.length} NFs',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final nf = filtered[index];
                      return _NfCard(
                        nf: nf,
                        onTap: () => _openDetail(nf),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _openDetail(EtiquetaNfSaidaStatus nf) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EtiquetaNfSaidaDetailPage(
          chave: nf.chaveNFe,
          notaFiscal: nf.notaFiscal,
          serie: nf.serie,
        ),
      ),
    );
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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "NF ${nf.notaFiscal} / ${nf.serie}",
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cliente: ${nf.nomeCliente}',
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Transp.: ${nf.nomeTransp}',
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Chip(
                    label: Text(
                      '${nf.qtdItens} ${nf.qtdItens == 1 ? "item" : "itens"}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
