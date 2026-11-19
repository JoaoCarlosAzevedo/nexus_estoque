import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:nexus_estoque/core/utils/safe_array_search_extension.dart';
import 'package:nexus_estoque/features/picking_load_v2/pages/picking_load_produts_list_grouped_page/widgets/picking_form_v2_grouped_modal.dart';

import '../../../../core/features/product_multiplier/pages/product_multiplier_modal.dart';
import '../../../picking/data/model/picking_model.dart';
import '../../data/model/pickingv2_model.dart';

import '../picking_load_list_page/cubit/picking_loadv2_cubit.dart';
import 'widgets/picking_product_grouped_card_v2.dart';

class PickingLoadProductListGroupedPage2 extends ConsumerStatefulWidget {
  const PickingLoadProductListGroupedPage2(
      {required this.warehouseStreets,
      required this.cubit,
      required this.load,
      required this.dateIni,
      required this.dateEnd,
      required this.department,
      this.order = '',
      super.key});
  //final List<PickingModel> products;
  final String warehouseStreets;
  final String department;
  final String load;
  final String dateIni;
  final String dateEnd;
  final String order;
  final PickingLoadv2Cubit cubit;

  bool get _filterByOrder => order.trim().isNotEmpty;

  void _reload() {
    if (_filterByOrder) {
      cubit.fetchPickingLoads(dateIni, dateEnd);
      return;
    }
    cubit.fetchPickingLoadsDeparment(load, department, dateIni, dateEnd);
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PickingLoadProductListGroupedPage2State();
}

class _PickingLoadProductListGroupedPage2State
    extends ConsumerState<PickingLoadProductListGroupedPage2> {
  late List<PickingModel> products;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("Carga: ${widget.load}"),
            if (widget._filterByOrder)
              Text("Pedido ${widget.order}")
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Dep. ${widget.department} / "),
                  Text("Rua ${widget.warehouseStreets}"),
                ],
              ),
            const Divider()
          ],
        ),
        actions: [
          IconButton(onPressed: widget._reload, icon: const Icon(Icons.refresh))
        ],
      ),
      body: BlocProvider.value(
        value: widget.cubit,
        child: BlocListener<PickingLoadv2Cubit, PickingLoadv2State>(
          listener: (context, state) {
            if (state is PickingLoadv2Loaded) {
              //se for filtro e retornar vazio significa q liberou toda a carga de filtro
              if (state.loads.isEmpty) {
                log("pop -> product_list -> state.loads empty");
                context.pop();
                return;
              }

              final index = state.loads
                  .indexWhere((element) => element.codCarga == widget.load);
              if (index == -1) {
                log("pop -> product_list -> state.loads sem carga");
                context.pop();
                return;
              }

              final index2 = state.loads[index].pedidos.indexWhere((element) =>
                  widget._filterByOrder
                      ? element.pedido.trim() == widget.order.trim()
                      : element.rua2 == widget.warehouseStreets &&
                          element.deposito == widget.department);

              if (index2 == -1) {
                log("pop -> product_list -> state.loads sem filtro");
                context.pop();
                return;
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
                List<LoadGroupProdModel> groupedProducts = [];

                final index = state.loads
                    .indexWhere((element) => element.codCarga == widget.load);
                if (index == -1) {
                  return const Center(
                    child: Text("Nenhum registro encontrado!"),
                  );
                }

                final loads = state.loads[index];

                final products = loads.pedidos
                    .where((element) => widget._filterByOrder
                        ? element.pedido.trim() == widget.order.trim()
                        : element.rua2 == widget.warehouseStreets &&
                            element.deposito == widget.department)
                    .toList();

                if (widget._filterByOrder) {
                  products.sort((a, b) {
                    final rua = a.rua2.compareTo(b.rua2);
                    if (rua != 0) return rua;
                    final predio = a.predio.compareTo(b.predio);
                    if (predio != 0) return predio;
                    return a.descEndereco2.compareTo(b.descEndereco2);
                  });
                } else {
                  products.sort(
                      ((a, b) => a.descEndereco2.compareTo(b.descEndereco2)));
                }

                if (state.loads.isEmpty) {
                  return const Center(
                    child: Text("Nenhum produto nessa rua."),
                  );
                }

                for (var element in products) {
                  LoadGroupProdModel? found =
                      groupedProducts.firstWhereOrNull((grouped) {
                    if (grouped.address.trim() == element.codEndereco.trim() &&
                        grouped.local.trim() == element.local.trim() &&
                        grouped.product.trim() == element.codigo.trim()) {
                      return true;
                    }
                    return false;
                  });

                  if (found == null) {
                    groupedProducts.add(LoadGroupProdModel(
                      load: state.load,
                      local: element.local,
                      quantity: element.quantidade,
                      quantityCheck: element.separado,
                      product: element.codigo,
                      barcode1: element.codigobarras,
                      barcode2: element.codigobarras2,
                      descrition: element.descricao,
                      address: element.codEndereco,
                      addressDescription: element.descEndereco2,
                      rua2: element.rua2,
                      deposito: element.deposito,
                      predio: element.predio,
                      nivel: element.nivel,
                      apartamento: element.apartamento,
                      products: [element],
                      fator: element.fator,
                    ));
                  } else {
                    found.products.add(element);
                  }
                }

                final groupByStreet = widget._filterByOrder;

                return GroupedListView<LoadGroupProdModel, String>(
                  elements: groupedProducts,
                  groupBy: (element) =>
                      groupByStreet ? element.rua2 : element.predio,
                  groupSeparatorBuilder: (String groupByValue) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          groupByStreet
                              ? "Rua $groupByValue"
                              : "Prédio $groupByValue",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        FaIcon(groupByStreet
                            ? FontAwesomeIcons.road
                            : FontAwesomeIcons.building)
                      ],
                    );
                  },
                  itemBuilder: (context, LoadGroupProdModel element) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PickingProductGroupedCardv2(
                        onAlterProd: () async {
                          final isSuccess = await showProductMultiplierModal(
                              context, element.product);
                          if (isSuccess > 0) {
                            widget._reload();
                          }
                        },
                        data: element,
                        onTap: () async {
                          final result =
                              await PickingFormv2GroupedGroupedModal.show(
                                  context, element);
                          if (result == "ok") {
                            widget._reload();
                          }
                        },
                      ),
                    );
                  },
                  itemComparator: (item1, item2) {
                    if (groupByStreet) {
                      final predio = item1.predio.compareTo(item2.predio);
                      if (predio != 0) return predio;
                    }
                    return item1.addressDescription
                        .compareTo(item2.addressDescription);
                  },
                  useStickyGroupSeparators: false, // optional
                  floatingHeader: false, // optional
                  order: GroupedListOrder.ASC, // optional
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
