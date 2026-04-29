import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/datetime_formatter.dart';
import '../../data/model/etiqueta_pedido_v3_model.dart';
import '../../data/model/filter_tag_load_order_model.dart';
import '../../data/repositories/filter_tag_order_repository.dart';
import '../filter_tags_order_load_page/cubit/filter_tag_order_load_cubit.dart';
import '../filter_tags_order_products_page/filter_tags_order_products_page.dart';
import '../filter_tags_orders/filter_tag_order_page.dart';

class FilterTagsOrdersV3Page extends ConsumerStatefulWidget {
  const FilterTagsOrdersV3Page({super.key});

  @override
  ConsumerState<FilterTagsOrdersV3Page> createState() =>
      _FilterTagsOrdersV3PageState();
}

class _FilterTagsOrdersV3PageState extends ConsumerState<FilterTagsOrdersV3Page> {
  late String dateIni;
  late String dateEnd;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  bool loading = true;
  String? loadError;
  List<EtiquetaPedidoV3Item> items = [];

  @override
  void initState() {
    super.initState();
    dateIni = datetimeToYYYYMMDD(DateTime.now());
    dateEnd = datetimeToYYYYMMDD(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchPedidos());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPedidos() async {
    setState(() {
      loading = true;
      loadError = null;
    });

    final result = await ref
        .read(filterTagRepositoryProvider)
        .fetchPedidosByDateRange(dateIni, dateEnd);

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          loading = false;
          loadError = failure.error;
          items = [];
        });
      },
      (list) {
        setState(() {
          loading = false;
          loadError = null;
          items = list;
        });
      },
    );
  }

  DateTime _dateFromYyyymmdd(String s) {
    if (s.length < 8) return DateTime.now();
    final y = int.tryParse(s.substring(0, 4)) ?? DateTime.now().year;
    final m = int.tryParse(s.substring(4, 6)) ?? 1;
    final d = int.tryParse(s.substring(6, 8)) ?? 1;
    return DateTime(y, m, d);
  }

  Future<void> _pickDateRange() async {
    final themeData = Theme.of(context);
    final initial = DateTimeRange(
      start: _dateFromYyyymmdd(dateIni),
      end: _dateFromYyyymmdd(dateEnd),
    );

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, Widget? child) => Theme(
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

    if (picked == null) return;

    setState(() {
      dateIni = datetimeToYYYYMMDD(picked.start);
      dateEnd = datetimeToYYYYMMDD(picked.end);
    });
    await _fetchPedidos();
  }

  Future<void> _openPedido(EtiquetaPedidoV3Item row) async {
    final repo = ref.read(filterTagRepositoryProvider);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    final result = await repo.fetchPedidoCompleto(row.pedido);

    if (!mounted) return;
    Navigator.of(context).pop();

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.error)),
        );
      },
      (dto) async {
        final load = dto.pedido;
        if (load.pedidos.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pedido sem itens.')),
          );
          return;
        }

        Orders selected;
        try {
          selected = load.pedidos.firstWhere(
            (o) => o.pedido.trim() == row.pedido.trim(),
          );
        } catch (_) {
          selected = load.pedidos.first;
        }

        final cubit = FilterTagLoadOrderCubit.prefetched(
          repo,
          load: load,
          selectedInvoice: selected,
          etiquetas: dto.etiquetas,
          skipCargaRefreshAfterPost: true,
        );

        await Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (context) => FilterTagsOrderProductsPage(
              cubit: cubit,
              orderBydate: '0-$dateIni-$dateEnd',
            ),
          ),
        );
      },
    );
  }

  List<EtiquetaPedidoV3Item> get _filtered {
    final q = searchQuery.toLowerCase().trim();
    if (q.isEmpty) return items;
    return items.where((row) {
      return row.pedido.toLowerCase().contains(q) ||
          row.codigoRota.toLowerCase().contains(q) ||
          row.descRota.toLowerCase().contains(q);
    }).toList();
  }

  String _subtitle(EtiquetaPedidoV3Item row) {
    final parts = <String>[];
    if (row.carga.isNotEmpty) parts.add('Carga: ${row.carga}');
    if (row.descRota.isNotEmpty || row.codigoRota.isNotEmpty) {
      final rota = [row.descRota, row.codigoRota]
          .where((s) => s.isNotEmpty)
          .join(' · ');
      if (rota.isNotEmpty) parts.add('Rota: $rota');
    }
    return parts.isEmpty ? '' : parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Etiqueta Pedido V3'),
            Text(
              '${yyyymmddToDate(dateIni)} - ${yyyymmddToDate(dateEnd)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _pickDateRange,
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildBody(filtered),
        ),
      ),
    );
  }

  Widget _buildBody(List<EtiquetaPedidoV3Item> filtered) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (loadError != null) {
      return Center(child: Text(loadError!));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Buscar por pedido ou rota...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        setState(() => searchQuery = '');
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() => searchQuery = value);
            },
          ),
        ),
        if (searchQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filtered.length} de ${items.length} pedidos encontrados',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ),
          ),
        const SizedBox(height: 8),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    items.isEmpty
                        ? 'Nenhum pedido no período.'
                        : 'Nenhum pedido corresponde à busca.',
                  ),
                )
              : ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final row = filtered[index];
                    final sub = _subtitle(row);
                    return Card(
                      child: ListTile(
                        onTap: () => _openPedido(row),
                        title: Text('Pedido: ${row.pedido}'),
                        subtitle: sub.isEmpty ? null : Text(sub),
                        trailing: IconButton(
                          tooltip: 'Etiquetas do pedido',
                          icon: const FaIcon(FontAwesomeIcons.boxOpen),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) => FilterTagsOrderPage(
                                  pedido: row.pedido,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
