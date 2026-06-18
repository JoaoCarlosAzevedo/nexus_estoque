import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../picking/data/model/picking_model.dart';
import '../picking_load_list_page/cubit/picking_load_cubit.dart';
import '../picking_load_product_list_page/picking_load_product_list_page.dart';
import '../picking_pallet_obs/cubit/picking_pallet_obs_cubit.dart';
import '../picking_pallet_obs/widgets/pallet_obs_layout.dart';

class PickingLoadStreetsPage extends ConsumerWidget {
  const PickingLoadStreetsPage(
      {required this.cubit,
      required this.load,
      required this.isPending,
      super.key});

  final String load;
  final PickingLoadCubit cubit;
  final bool isPending;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Carga $load"),
          actions: [
            BlocBuilder<PickingLoadCubit, PickingLoadState>(
              builder: (context, state) {
                final isObsPed = state is PickingLoadLoaded &&
                    state.loads.any(
                      (element) =>
                          element.codCarga == load && element.isObsPed,
                    );

                return PalletObsAppBarAction(enablePanel: isObsPed);
              },
            ),
            IconButton(
                onPressed: () {
                  cubit.fetchPickingLoads(isPending);
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

                final loadData = state.loads[index];
                final products = loadData.produtos;
                final isObsPed = loadData.isObsPed;

                final list = GroupedListView<PickingModel, String>(
                  elements: products,
                  groupBy: (element) => element.rua,
                  groupSeparatorBuilder: (String groupByValue) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Card(
                        child: ListTile(
                          title: Text("Rua $groupByValue"),
                          onTap: () {
                            final palletObsCubit =
                                context.read<PickingPalletObsCubit>();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: palletObsCubit,
                                  child: PickingLoadProductListPage(
                                    warehouseStreets: groupByValue,
                                    cubit: cubit,
                                    load: load,
                                    isPending: isPending,
                                  ),
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
