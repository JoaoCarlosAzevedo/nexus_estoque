import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../picking_load_v2/data/model/pickingv2_model.dart';
import '../../picking_load_v2/pages/picking_load_list_page/cubit/picking_loadv2_cubit.dart';

class PickingLoadOrdersPage extends ConsumerWidget {
  const PickingLoadOrdersPage(
      {required this.cubit,
      required this.load,
      super.key,
      required this.dateIni,
      required this.dateEnd});

  final String load;
  final PickingLoadv2Cubit cubit;

  final String dateIni;
  final String dateEnd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late List<Pickingv2Model> orders;

    return Scaffold(
      appBar: AppBar(
        title: Text("Carga $load"),
        actions: [
          IconButton(
              onPressed: () {
                cubit.fetchPickingLoads(dateIni, dateEnd);
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: BlocProvider.value(
        value: cubit,
        child: BlocListener<PickingLoadv2Cubit, PickingLoadv2State>(
          listener: (context, state) {
            if (state is PickingLoadv2Loaded) {
              if (state.loads.isEmpty) {
                log("pop -> street_page -> state.loads empty");
                context.pop();
                return;
              }

              final index =
                  state.loads.indexWhere((element) => element.codCarga == load);
              if (index == -1) {
                log("pop -> street_page -> state.loads sem carga");
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
                    .indexWhere((element) => element.codCarga == load);
                if (index == -1) {
                  return const Center(
                    child: Text("Nenhum registro encontrado!"),
                  );
                }
                orders = state.loads[index].pedidos;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GroupedListView<Pickingv2Model, String>(
                    elements: orders.toList(),
                    groupBy: (element) => element.pedido,
                    groupSeparatorBuilder: (String groupByValue) {
                      final qtdProd = orders
                          .where(
                            (element) => element.pedido.trim() == groupByValue,
                          )
                          .toList();
                      return GestureDetector(
                        onTap: () {
                          print(groupByValue);
                        },
                        child: Card(
                          child: ListTile(
                            title: Text("Pedido $groupByValue"),
                            subtitle: Text("Qtd. Itens ${qtdProd.length}"),
                            trailing:
                                const FaIcon(FontAwesomeIcons.clipboardCheck),
                          ),
                        ),

                        /* Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Pedido $groupByValue",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                const FaIcon(FontAwesomeIcons.clipboardCheck)
                              ],
                            ),
                          ),
                        ), */
                      );
                    },
                    itemBuilder: (context, element) {
                      return Container();
                      /*    return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Card(
                          child: ListTile(
                            title: Text('Pedido: ${element.pedido}'),
                            leading: const FaIcon(FontAwesomeIcons.road),
                            onTap: () {
                              /*      Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PickingLoadProductListGroupedPage2(
                                    warehouseStreets: element['rua'],
                                    department: element['departamento'],
                                    cubit: cubit,
                                    load: load,
                                    dateIni: dateIni,
                                    dateEnd: dateEnd,
                                  ),
                                ),
                              ); */
                            },
                          ),
                        ),
                      ); */
                    },
                    itemComparator: (item1, item2) =>
                        item1.pedido.compareTo(item2.pedido), // optional
                    useStickyGroupSeparators: false, // optional
                    floatingHeader: false, // optional
                    order: GroupedListOrder.ASC, // optional
                  ),
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
