import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:nexus_estoque/core/theme/app_theme.dart';

import '../../picking_load_v2/data/model/pickingv2_model.dart';
import '../../picking_load_v2/pages/picking_form_v2_page/picking_form_v3_modal.dart';
import '../../picking_load_v2/pages/picking_load_produts_list_page/widgets/picking_product_card_v2.dart';
import 'cubit/picking_orders_v2_cubit.dart';

class PickingOrdersV2ProductsPage extends ConsumerWidget {
  const PickingOrdersV2ProductsPage({
    required this.cubit,
    required this.order,
    super.key,
  });

  final String order;
  final PickingOrdersV2Cubit cubit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late List<Pickingv2Model> products;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("Pedido: $order"),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                cubit.fetchPickingOrdersv2();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: BlocProvider.value(
        value: cubit,
        child: BlocListener<PickingOrdersV2Cubit, PickingOrdersV2State>(
          listener: (context, state) {
            if (state is PickingOrdersV2Loaded) {
              if (state.loads.isEmpty) {
                context.pop(false);
              }

              final index2 =
                  state.loads.indexWhere((e) => e.pedido.trim() == order);
              if (index2 == -1) {
                context.pop(true);
              }
            }
          },
          child: BlocBuilder<PickingOrdersV2Cubit, PickingOrdersV2State>(
            builder: (context, state) {
              if (state is PickingOrdersV2Loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is PickingOrdersV2Error) {
                return Center(
                  child: Text("Erro: ${state.error.error}"),
                );
              }

              if (state is PickingOrdersV2Loaded) {
                if (state.loads.isEmpty) {
                  return const Center(
                    child: Text("Nenhum registro encontrado!"),
                  );
                }
                products =
                    state.loads.where((e) => e.pedido.trim() == order).toList();

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GroupedListView<Pickingv2Model, String>(
                    elements: products,
                    groupBy: (element) => element.descEndereco2,
                    groupSeparatorBuilder: (String groupByValue) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 14),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              groupByValue,
                              style: AppTheme.customTextTheme().titleLarge,
                            ),
                          ],
                        ),
                      );
                    },
                    itemBuilder: (context, Pickingv2Model element) {
                      return PickingProductCardv2(
                        data: element,
                        onTap: () async {
                          final result =
                              await PickingFormv3Modal.show(context, element);
                          if (result == "ok") {
                            cubit.fetchPickingOrdersv2();
                          }
                        },
                      );
                    },
                    itemComparator: (item1, item2) => item1.descEndereco2
                        .compareTo(item2.descEndereco2), // optional
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
