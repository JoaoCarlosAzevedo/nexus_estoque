import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/picking_load_v2/pages/picking_load_list_page/cubit/picking_loadv2_cubit.dart';

import '../../data/model/shippingv2_model.dart';
import '../../data/repositories/pickingv2_repository.dart';
import '../picking_load_streets_list_page/picking_load_v2_streets_page.dart';
import '../picking_load_v2_order_page/picking_load_v2_order_page.dart';
import 'widgets/load_v2_card_widget.dart';

class PickingLoadListPagev2 extends ConsumerStatefulWidget {
  const PickingLoadListPagev2({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PickingLoadListPagev2State();
}

class _PickingLoadListPagev2State extends ConsumerState<PickingLoadListPagev2> {
  bool filterFaturado = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PickingLoadv2Cubit(ref.read(pickingv2RepositoryProvider)),
      child: BlocBuilder<PickingLoadv2Cubit, PickingLoadv2State>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Cargas"),
              actions: [
                IconButton(
                    onPressed: () {
                      context.read<PickingLoadv2Cubit>().fetchPickingLoads();
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<PickingLoadv2Cubit, PickingLoadv2State>(
                  builder: (context, state) {
                    if (state is PickingLoadv2Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is PickingLoadv2Error) {
                      return Center(
                        child: Text(state.error.error),
                      );
                    }

                    if (state is PickingLoadv2Loaded) {
                      List<Shippingv2Model> data = [];

                      if (filterFaturado) {
                        data = state.loads
                            .where((element) => element.isFaturado())
                            .toList();
                      } else {
                        //data = state.loads;
                        data = state.loads
                            .where((element) => !element.isFaturado())
                            .toList();
                      }

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text("Filtra Faturados? "),
                              const SizedBox(
                                width: 15,
                              ),
                              Switch(
                                value: filterFaturado,
                                activeColor: Colors.green,
                                inactiveTrackColor: Colors.grey,
                                onChanged: (bool value) {
                                  // This is called when the user toggles the switch.
                                  setState(() {
                                    filterFaturado = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return Loadv2CardWidget(
                                  load: data[index],
                                  onSearch: () {
                                    final cubit =
                                        context.read<PickingLoadv2Cubit>();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PickingLoadv2OrderStatusPage(
                                          cubit: cubit,
                                          load: data[index].codCarga,
                                        ),
                                      ),
                                    );
                                  },
                                  onTap: () {
                                    final cubit =
                                        context.read<PickingLoadv2Cubit>();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PickingLoadStreetsPagev2(
                                          cubit: cubit,
                                          load: data[index].codCarga,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
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
