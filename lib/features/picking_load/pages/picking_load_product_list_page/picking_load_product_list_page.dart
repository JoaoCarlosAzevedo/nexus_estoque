import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../picking/data/model/picking_model.dart';
import '../../../picking/pages/picking_form/picking_form_modal.dart';
import '../../../picking/pages/picking_products_list/widgets/picking_product_card_wigdet.dart';
import '../picking_load_list_page/cubit/picking_load_cubit.dart';
import '../picking_pallet_obs/cubit/picking_pallet_obs_cubit.dart';
import '../picking_pallet_obs/widgets/pallet_obs_layout.dart';

class PickingLoadProductListPage extends ConsumerStatefulWidget {
  const PickingLoadProductListPage(
      {required this.warehouseStreets,
      required this.cubit,
      required this.load,
      required this.isPending,
      super.key});
  //final List<PickingModel> products;
  final String warehouseStreets;
  final String load;
  final PickingLoadCubit cubit;
  final bool isPending;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PickingLoadProductListPageState();
}

class _PickingLoadProductListPageState
    extends ConsumerState<PickingLoadProductListPage> {
  late List<PickingModel> products;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text("Carga: ${widget.load}"),
              Text("Rua ${widget.warehouseStreets}"),
            ],
          ),
          actions: [
            BlocBuilder<PickingLoadCubit, PickingLoadState>(
              builder: (context, state) {
                final isObsPed = state is PickingLoadLoaded &&
                    state.loads.any(
                      (element) =>
                          element.codCarga == widget.load && element.isObsPed,
                    );

                return PalletObsAppBarAction(enablePanel: isObsPed);
              },
            ),
            IconButton(
                onPressed: () {
                  widget.cubit.fetchPickingLoads(widget.isPending);
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: BlocListener<PickingLoadCubit, PickingLoadState>(
          listener: (context, state) {
            if (state is PickingLoadLoaded) {
              if (state.loads.isEmpty) {
                context.pop();
                return;
              }
              final index = state.loads
                  .indexWhere((element) => element.codCarga == widget.load);
              if (index == -1) {
                context.pop();
                return;
              }

              final index2 = state.loads[index].produtos.indexWhere(
                  (element) => element.rua == widget.warehouseStreets);

              if (index2 == -1) {
                context.pop();
                return;
              }
            }
          },
          child: BlocBuilder<PickingLoadCubit, PickingLoadState>(
            builder: (context, state) {
              if (state is PickingLoadLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is PickingLoadError) {
                return Center(
                  child: Text("Erro: ${state.error.error}"),
                );
              }

              if (state is PickingLoadLoaded) {
                final index = state.loads
                    .indexWhere((element) => element.codCarga == widget.load);
                if (index == -1) {
                  return const Center(
                    child: Text("Nenhum registro encontrado!"),
                  );
                }

                final loads = state.loads[index];

                final products = loads.produtos
                    .where((element) => element.rua == widget.warehouseStreets)
                    .toList();

                /* products
                    .sort(((a, b) => a.descEndereco.compareTo(b.descEndereco))); */

                if (state.loads.isEmpty) {
                  return const Center(
                    child: Text("Nenhum produto nessa rua."),
                  );
                }

                final isObsPed = loads.isObsPed;

                final list = GroupedListView<PickingModel, String>(
                  elements: products,
                  groupBy: (element) => element.descEndereco.substring(6),
                  groupSeparatorBuilder: (String groupByValue) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12, left: 8),
                      child: Text('Endereço $groupByValue'),
                    );
                  },
                  itemBuilder: (context, PickingModel element) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PickingProductCard(
                        data: element,
                        onTap: () async {
                          if (element.separado >= element.quantidade) {
                            AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    desc: "Item já separado!",
                                    btnOkOnPress: () {},
                                    btnOkColor: Theme.of(context).primaryColor)
                                .show();
                          } else {
                            final previousSeparado = element.separado;
                            final result =
                                await PickingFormModal.show(context, element);
                            if (result == "ok") {
                              if (isObsPed && context.mounted) {
                                final delta =
                                    element.separado - previousSeparado;
                                if (delta > 0) {
                                  context
                                      .read<PickingPalletObsCubit>()
                                      .addItem(
                                        pedido: element.pedido,
                                        codigo: element.codigo,
                                        descricao: element.descricao,
                                        quantidade: delta,
                                      );
                                }
                              }
                              widget.cubit.fetchPickingLoads(widget.isPending);
                            }
                          }
                        },
                      ),
                    );
                  },
                  itemComparator: (item1, item2) => item1.descEndereco
                      .substring(7)
                      .compareTo(item2.descEndereco.substring(7)), // optional
                  useStickyGroupSeparators: false, // optional
                  floatingHeader: false, // optional
                  order: GroupedListOrder.ASC, // optional
                );

                if (!isObsPed) {
                  return list;
                }

                return PalletObsLayout(
                  enablePanel: isObsPed,
                  child: list,
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

