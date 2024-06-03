import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../picking/data/model/picking_model.dart';
import '../../data/model/pickingv2_model.dart';
import '../picking_form_v2_page/picking_form_v2_modal.dart';
import '../picking_load_list_page/cubit/picking_loadv2_cubit.dart';
import 'widgets/picking_product_card_v2.dart';

class PickingLoadProductListPage2 extends ConsumerStatefulWidget {
  const PickingLoadProductListPage2(
      {required this.warehouseStreets,
      required this.cubit,
      required this.load,
      required this.department,
      super.key});
  //final List<PickingModel> products;
  final String warehouseStreets;
  final String department;
  final String load;
  final PickingLoadv2Cubit cubit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PickingLoadProductListPage2State();
}

class _PickingLoadProductListPage2State
    extends ConsumerState<PickingLoadProductListPage2> {
  late List<PickingModel> products;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("Carga: ${widget.load}"),
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
          IconButton(
              onPressed: () {
                //widget.cubit.fetchPickingLoads();
                widget.cubit
                    .fetchPickingLoadsDeparment(widget.load, widget.department);
              },
              icon: const Icon(Icons.refresh))
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
                  element.rua2 == widget.warehouseStreets &&
                  element.deposito == widget.department);

              if (index2 == -1) {
                log("pop -> product_list -> state.loads sem dep/rua");
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
                final index = state.loads
                    .indexWhere((element) => element.codCarga == widget.load);
                if (index == -1) {
                  return const Center(
                    child: Text("Nenhum registro encontrado!"),
                  );
                }

                final loads = state.loads[index];

                final products = loads.pedidos
                    .where((element) =>
                        element.rua2 == widget.warehouseStreets &&
                        element.deposito == widget.department)
                    .toList();

                products.sort(
                    ((a, b) => a.descEndereco2.compareTo(b.descEndereco2)));

                if (state.loads.isEmpty) {
                  return const Center(
                    child: Text("Nenhum produto nessa rua."),
                  );
                }
                return GroupedListView<Pickingv2Model, String>(
                  elements: products,
                  groupBy: (element) => element.predio,
                  groupSeparatorBuilder: (String groupByValue) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Prédio $groupByValue",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const FaIcon(FontAwesomeIcons.building)
                      ],
                    );
                  },
                  itemBuilder: (context, Pickingv2Model element) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PickingProductCardv2(
                        data: element,
                        onTap: () async {
                          final result =
                              await PickingFormv2v2Modal.show(context, element);
                          if (result == "ok") {
                            widget.cubit.fetchPickingLoadsDeparment(
                                widget.load, widget.department);
                          }
                        },
                      ),
                    );
                  },
                  itemComparator: (item1, item2) => item1.descEndereco2
                      .compareTo(item2.descEndereco2), // optional
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
