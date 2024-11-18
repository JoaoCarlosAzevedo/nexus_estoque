import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../picking_load_v2/data/model/pickingv2_model.dart';

import '../data/repositories/picking_orders_v2_repository.dart';
import 'cubit/picking_orders_v2_cubit.dart';
import 'picking_orders_v2_products_page.dart';

class PickingOrdersV2List extends ConsumerStatefulWidget {
  const PickingOrdersV2List({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PickingOrdersV2ListState();
}

class _PickingOrdersV2ListState extends ConsumerState<PickingOrdersV2List> {
  bool filterFaturado = false;

  @override
  Widget build(BuildContext context) {
    late List<Pickingv2Model> orders;
    return BlocProvider(
      create: (context) =>
          PickingOrdersV2Cubit(ref.read(pickingOrdersV2RepositoryProvider)),
      child: BlocBuilder<PickingOrdersV2Cubit, PickingOrdersV2State>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Pedidos"),
              actions: [
                IconButton(
                    onPressed: () {
                      context
                          .read<PickingOrdersV2Cubit>()
                          .fetchPickingOrdersv2();
                    },
                    icon: const Icon(Icons.refresh)),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<PickingOrdersV2Cubit, PickingOrdersV2State>(
                  builder: (context, state) {
                    if (state is PickingOrdersV2Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is PickingOrdersV2Error) {
                      return Center(
                        child: Text(state.error.error),
                      );
                    }

                    if (state is PickingOrdersV2Loaded) {
                      List<Pickingv2Model> data = state.loads;

                      orders = data;

                      if (orders.isEmpty) {
                        return const Center(
                          child: Text("Nenhum registro encontrado."),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GroupedListView<Pickingv2Model, String>(
                          elements: orders.toList(),
                          groupBy: (element) => element.pedido,
                          groupSeparatorBuilder: (String groupByValue) {
                            final qtdProd = orders
                                .where(
                                  (element) =>
                                      element.pedido.trim() == groupByValue,
                                )
                                .toList();
                            return GestureDetector(
                              onTap: () {
                                final cubit =
                                    context.read<PickingOrdersV2Cubit>();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PickingOrdersV2ProductsPage(
                                      cubit: cubit,
                                      order: groupByValue,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text("Pedido $groupByValue"),
                                  subtitle:
                                      Text("Qtd. Itens ${qtdProd.length}"),
                                  trailing: const FaIcon(
                                      FontAwesomeIcons.clipboardCheck),
                                ),
                              ),
                            );
                          },
                          itemBuilder: (context, element) {
                            return Container();
                          },
                          itemComparator: (item1, item2) =>
                              item1.pedido.compareTo(item2.pedido), // optional
                          useStickyGroupSeparators: false, // optional
                          floatingHeader: false, // optional
                          order: GroupedListOrder.ASC, // optional
                        ),
                      );
                    }
                    return const Text("Initial");
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
