import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:nexus_estoque/core/theme/app_theme.dart';

import '../../../outflow_doc_check/pages/outflow_doc_page/widgets/progress_indicator_widget.dart';
import '../../data/model/pickingv2_model.dart';
import '../picking_load_list_page/cubit/picking_loadv2_cubit.dart';
import '../picking_load_produts_list_page/widgets/picking_product_card_v2.dart';

class PickingLoadv2OrderStatusPage extends ConsumerWidget {
  const PickingLoadv2OrderStatusPage(
      {required this.cubit,
      required this.load,
      super.key,
      required this.dateIni,
      required this.dateEnd});

  final String load;
  final String dateIni;
  final String dateEnd;
  final PickingLoadv2Cubit cubit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late List<Pickingv2Model> products;

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
                context.pop();
              }
              final index =
                  state.loads.indexWhere((element) => element.codCarga == load);
              if (index == -1) {
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
                    .indexWhere((element) => element.codCarga == load);
                if (index == -1) {
                  return const Center(
                    child: Text("Nenhum registro encontrado!"),
                  );
                }
                products = state.loads[index].pedidos;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GroupedListView<Pickingv2Model, String>(
                    elements: products,
                    groupBy: (element) => element.pedido,
                    groupSeparatorBuilder: (String groupByValue) {
                      products
                          .where((element) => element.pedido == groupByValue);

                      final qtd = products.fold(
                        0.0,
                        (value, element) => value + element.quantidade,
                      );
                      final checked = products.fold(
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
                              )
                          ],
                        ),
                      );
                    },
                    itemBuilder: (context, Pickingv2Model element) {
                      return PickingProductCardv2(
                        data: element,
                        onTap: () async {},
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
