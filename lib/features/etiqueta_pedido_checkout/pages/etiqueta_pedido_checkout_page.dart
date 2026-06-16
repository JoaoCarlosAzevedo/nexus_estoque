import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/widgets/form_input_no_keyboard_search_widget.dart';
import '../../filter_tags_orders/data/model/etiqueta_pedido_v3_model.dart';
import '../../filter_tags_orders/data/model/filter_tag_load_order_model.dart';
import '../../filter_tags_orders/data/repositories/filter_tag_order_repository.dart';
import '../../filter_tags_orders/pages/filter_tags_order_load_page/cubit/filter_tag_order_load_cubit.dart';
import '../../filter_tags_orders/pages/filter_tags_order_products_page/filter_tags_order_products_page.dart';
import '../../filter_tags_orders/pages/filter_tags_orders/filter_tag_order_page.dart';

class EtiquetaPedidoCheckoutPage extends ConsumerStatefulWidget {
  const EtiquetaPedidoCheckoutPage({super.key});

  @override
  ConsumerState<EtiquetaPedidoCheckoutPage> createState() =>
      _EtiquetaPedidoCheckoutPageState();
}

class _EtiquetaPedidoCheckoutPageState
    extends ConsumerState<EtiquetaPedidoCheckoutPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  bool _loading = false;
  String? _error;
  List<EtiquetaPedidoV3Item> _results = [];
  String? _lastScanned;

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _scan(String code) async {
    final cod = code.trim();
    if (cod.isEmpty) {
      _focus.requestFocus();
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _results = [];
      _lastScanned = cod;
    });

    final res = await ref
        .read(filterTagRepositoryProvider)
        .fetchPedidosByEtiquetaCheckout(cod);

    if (!mounted) return;

    _controller.clear();

    res.fold(
      (failure) => setState(() {
        _error = failure.error;
        _loading = false;
      }),
      (list) => setState(() {
        _results = list;
        _loading = false;
      }),
    );

    if (mounted) {
      _focus.requestFocus();
    }
  }

  void _clear() {
    setState(() {
      _results = [];
      _error = null;
      _lastScanned = null;
    });
    _controller.clear();
    _focus.requestFocus();
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

    await result.fold(
      (failure) async {
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
              orderBydate: null,
            ),
          ),
        );
      },
    );
  }

  Widget _buildResults() {
    if (_loading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
    }

    if (_results.isEmpty) {
      if (_lastScanned == null) {
        return const Expanded(
          child: Center(
            child: Text('Bipe ou digite a etiqueta de checkout.'),
          ),
        );
      }
      return Expanded(
        child: Center(
          child: Text('Nenhum pedido para a etiqueta $_lastScanned'),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final row = _results[index];
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Etiqueta Pedido via Checkout'),
        actions: [
          IconButton(
            onPressed: _clear,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              NoKeyboardTextSearchForm(
                controller: _controller,
                focusNode: _focus,
                autoFocus: true,
                label: 'Etiqueta de Checkout',
                onSubmitted: _scan,
              ),
              _buildResults(),
            ],
          ),
        ),
      ),
    );
  }
}
