import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../picking_orders_v2/pages/widgets/picking_order_summary_card.dart';
import '../../data/model/pickingv2_model.dart';
import '../picking_load_list_page/cubit/picking_loadv2_cubit.dart';
import '../picking_load_produts_list_grouped_page/picking_load_v2_product_grouped_page.dart';

class PickingLoadFaturamentoOrdersPage extends ConsumerStatefulWidget {
  const PickingLoadFaturamentoOrdersPage({
    required this.cubit,
    required this.load,
    required this.dateIni,
    required this.dateEnd,
    super.key,
  });

  final String load;
  final PickingLoadv2Cubit cubit;
  final String dateIni;
  final String dateEnd;

  @override
  ConsumerState<PickingLoadFaturamentoOrdersPage> createState() =>
      _PickingLoadFaturamentoOrdersPageState();
}

class _PickingLoadFaturamentoOrdersPageState
    extends ConsumerState<PickingLoadFaturamentoOrdersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("Carga: ${widget.load}"),
            const Text("Pedidos"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              widget.cubit.fetchPickingLoads(widget.dateIni, widget.dateEnd);
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: BlocProvider.value(
        value: widget.cubit,
        child: BlocListener<PickingLoadv2Cubit, PickingLoadv2State>(
          listener: (context, state) {
            if (state is PickingLoadv2Loaded) {
              if (state.loads.isEmpty) {
                log("pop -> faturamento_orders -> state.loads empty");
                context.pop();
                return;
              }

              final index = state.loads
                  .indexWhere((element) => element.codCarga == widget.load);
              if (index == -1) {
                log("pop -> faturamento_orders -> state.loads sem carga");
                context.pop();
              }
            }
          },
          child: BlocBuilder<PickingLoadv2Cubit, PickingLoadv2State>(
            builder: (context, state) {
              if (state is PickingLoadv2Loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is PickingLoadv2Error) {
                return Center(
                  child: Text("Erro: ${state.error.error}"),
                );
              }

              if (state is PickingLoadv2Loaded) {
                final index = state.loads
                    .indexWhere((element) => element.codCarga == widget.load);
                if (index == -1) {
                  return const Center(
                    child: Text("Nenhum registro encontrado!"),
                  );
                }

                var orders =
                    List<Pickingv2Model>.from(state.loads[index].pedidos);

                if (_searchQuery.isNotEmpty) {
                  final matchingPedidos = orders
                      .where((order) =>
                          order.pedido.toLowerCase().contains(_searchQuery) ||
                          order.nf.toLowerCase().contains(_searchQuery))
                      .map((order) => order.pedido.trim())
                      .toSet();
                  orders = orders
                      .where((order) =>
                          matchingPedidos.contains(order.pedido.trim()))
                      .toList();
                }

                orders.sort((a, b) {
                  final aRetiraPreenchido = a.retira.trim().isNotEmpty;
                  final bRetiraPreenchido = b.retira.trim().isNotEmpty;
                  if (aRetiraPreenchido != bRetiraPreenchido) {
                    return (bRetiraPreenchido ? 1 : 0)
                        .compareTo(aRetiraPreenchido ? 1 : 0);
                  }
                  return a.pedido.compareTo(b.pedido);
                });

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Buscar pedido ou NF...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: orders.isEmpty
                          ? const Center(
                              child: Text("Nenhum registro encontrado."),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GroupedListView<Pickingv2Model, String>(
                                elements: orders,
                                groupBy: (element) =>
                                    '${element.retira.trim().isEmpty ? '1' : '0'}_${element.pedido}',
                                groupSeparatorBuilder: (String groupByValue) {
                                  final pedido = groupByValue.contains('_')
                                      ? groupByValue.substring(
                                          groupByValue.indexOf('_') + 1)
                                      : groupByValue;
                                  final qtdProd = orders
                                      .where((element) =>
                                          element.pedido.trim() == pedido)
                                      .toList();
                                  final isFaturado = qtdProd.any((element) =>
                                      element.status.trim() == "Faturado");
                                  final nfs = qtdProd
                                      .map((element) => element.nf.trim())
                                      .where((nf) => nf.isNotEmpty)
                                      .toSet()
                                      .join(', ');
                                  final rotas = qtdProd
                                      .map((element) => element.rota.trim())
                                      .where((rota) => rota.isNotEmpty)
                                      .toSet()
                                      .join(', ');

                                  return PickingOrderSummaryCard(
                                    pedido: pedido,
                                    rotas: rotas,
                                    isFaturado: isFaturado,
                                    isRetira: qtdProd.isNotEmpty &&
                                        qtdProd.first.retira.trim().isNotEmpty,
                                    cliente: qtdProd.isNotEmpty
                                        ? qtdProd.first.desCli
                                        : '',
                                    nfs: nfs,
                                    qtdItens: qtdProd.length,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PickingLoadProductListGroupedPage2(
                                            warehouseStreets: '',
                                            department: '',
                                            cubit: widget.cubit,
                                            load: widget.load,
                                            dateIni: widget.dateIni,
                                            dateEnd: widget.dateEnd,
                                            order: pedido,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                itemBuilder: (context, element) {
                                  return const SizedBox.shrink();
                                },
                                itemComparator: (item1, item2) =>
                                    item1.pedido.compareTo(item2.pedido),
                                useStickyGroupSeparators: false,
                                floatingHeader: false,
                                order: GroupedListOrder.ASC,
                              ),
                            ),
                    ),
                  ],
                );
              }

              return const Center(
                child: Text("Bad state!"),
              );
            },
          ),
        ),
      ),
    );
  }
}
