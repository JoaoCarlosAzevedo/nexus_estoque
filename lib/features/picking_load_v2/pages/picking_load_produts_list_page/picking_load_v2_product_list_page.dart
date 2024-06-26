import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../picking/data/model/picking_model.dart';
import '../../../picking/pages/picking_form/picking_form_modal.dart';
import '../../../picking_load/pages/picking_load_list_page/cubit/picking_load_cubit.dart';
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
  final PickingLoadCubit cubit;

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
                widget.cubit.fetchPickingLoads();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: BlocProvider.value(
        value: widget.cubit,
        child: BlocListener<PickingLoadCubit, PickingLoadState>(
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

              final index2 = state.loads[index].produtos.indexWhere((element) =>
                  element.rua2 == widget.warehouseStreets &&
                  element.deposito == widget.department);

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
                return GroupedListView<PickingModel, String>(
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
                  itemBuilder: (context, PickingModel element) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PickingProductCardv2(
                        data: element,
                        onTap: () async {
                          final result =
                              await PickingFormModal.show(context, element);
                          if (result == "ok") {
                            widget.cubit.fetchPickingLoads();
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
