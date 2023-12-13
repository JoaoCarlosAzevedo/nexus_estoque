import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../picking/data/model/picking_model.dart';
import '../picking_load_list_page/cubit/picking_load_cubit.dart';
import '../picking_load_product_list_page/picking_load_product_list_page.dart';

class PickingLoadStreetsPage extends ConsumerWidget {
  const PickingLoadStreetsPage(
      {required this.cubit, required this.load, super.key});

  final String load;
  final PickingLoadCubit cubit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late List<PickingModel> products;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ruas"),
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
        child: BlocListener<PickingLoadCubit, PickingLoadState>(
          listener: (context, state) {
            if (state is PickingLoadLoaded) {
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
                    .indexWhere((element) => element.codCarga == load);
                if (index == -1) {
                  return const Center(
                    child: Text("Nenhum registro encontrado!"),
                  );
                }
                products = state.loads[index].produtos;

                return GroupedListView<PickingModel, String>(
                  elements: products,
                  groupBy: (element) => element.rua,
                  groupSeparatorBuilder: (String groupByValue) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Card(
                        child: ListTile(
                          title: Text("Rua $groupByValue"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PickingLoadProductListPage(
                                  warehouseStreets: groupByValue,
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
                  itemBuilder: (context, PickingModel element) {
                    return const Visibility(visible: false, child: Text("a"));
                  },
                  itemComparator: (item1, item2) => item1.descEndereco
                      .compareTo(item2.descEndereco), // optional
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
