import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:nexus_estoque/core/theme/app_theme.dart';

import '../../../outflow_doc_check/pages/outflow_doc_page/widgets/progress_indicator_widget.dart';
import '../../../picking/data/model/picking_model.dart';
import '../../../picking/pages/picking_products_list/widgets/picking_product_card_wigdet.dart';
import '../picking_load_list_page/cubit/picking_load_cubit.dart';

class PickingLoadOrderStatusPage extends ConsumerWidget {
  const PickingLoadOrderStatusPage(
      {required this.cubit,
      required this.load,
      required this.isPending,
      super.key});

  final String load;
  final PickingLoadCubit cubit;
  final bool isPending;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late List<PickingModel> products;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("Carga: $load"),
            const Text("Status Pedidos"),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                cubit.fetchPickingLoads(isPending);
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
              }
              final index =
                  state.loads.indexWhere((element) => element.codCarga == load);
              if (index == -1) {
                context.pop();
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

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GroupedListView<PickingModel, String>(
                    elements: products,
                    groupBy: (element) => element.pedido,
                    groupSeparatorBuilder: (String groupByValue) {
                      final orderProducts = products
                          .where((element) => element.pedido == groupByValue);

                      final qtd = orderProducts.fold(
                        0.0,
                        (value, element) => value + element.quantidade,
                      );
                      final checked = orderProducts.fold(
                        0.0,
                        (value, element) => value + element.separado,
                      );

                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 14),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pedido $groupByValue',
                              style: AppTheme.customTextTheme().titleLarge,
                            ),
                            if (qtd > 0)
                              ProgressIndicatorWidget(
                                value: checked / qtd,
                              ),
                          ],
                        ),
                      );
                    },
                    itemBuilder: (context, PickingModel element) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PickingProductCard(
                          data: element,
                          onTap: () async {},
                        ),
                      );
                    },
                    itemComparator: (item1, item2) => item1.descEndereco
                        .compareTo(item2.descEndereco), // optional
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
