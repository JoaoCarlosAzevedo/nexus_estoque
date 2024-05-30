import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../data/model/pickingv2_model.dart';
import '../picking_load_list_page/cubit/picking_loadv2_cubit.dart';
import '../picking_load_produts_list_page/picking_load_v2_product_list_page.dart';

class PickingLoadStreetsPagev2 extends ConsumerWidget {
  const PickingLoadStreetsPagev2(
      {required this.cubit, required this.load, super.key});

  final String load;
  final PickingLoadv2Cubit cubit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late List<Pickingv2Model> products;

    return Scaffold(
      appBar: AppBar(
        title: Text("Carga $load"),
        actions: [
          IconButton(
              onPressed: () {
                cubit.fetchPickingLoads();
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
                context.pop();
                return;
              }
              final index =
                  state.loads.indexWhere((element) => element.codCarga == load);
              if (index == -1) {
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
                products = state.loads[index].pedidos;
                final listOfStreets = <Map<String, String>>{};
                final list = products
                    .map(
                      (e) => {'departamento': e.deposito, 'rua': e.rua2},
                    )
                    .toList();

                for (var item in list) {
                  // If a map with the same name exists don't add the item.
                  if (listOfStreets.any((e) =>
                      '${e['departamento']}+${e['rua']}' ==
                      '${item['departamento']}+${item['rua']}')) {
                    continue;
                  }
                  listOfStreets.add(item);
                }

                return GroupedListView<Map, String>(
                  elements: listOfStreets.toList(),
                  groupBy: (element) => element['departamento'],
                  groupSeparatorBuilder: (String groupByValue) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Departamento $groupByValue",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          const FaIcon(FontAwesomeIcons.warehouse)
                        ],
                      ),
                    );
                  },
                  itemBuilder: (context, element) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Card(
                        child: ListTile(
                          title: Text('Rua: ${element['rua']}'),
                          leading: const FaIcon(FontAwesomeIcons.road),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PickingLoadProductListPage2(
                                  warehouseStreets: element['rua'],
                                  department: element['departamento'],
                                  cubit: cubit,
                                  load: load,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  itemComparator: (item1, item2) =>
                      item1['rua'].compareTo(item2['rua']), // optional
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
