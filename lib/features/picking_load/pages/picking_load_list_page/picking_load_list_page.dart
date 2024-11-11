import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../picking_route/data/repositories/picking_route_repository.dart';
import '../picking_load_order_status_page/picking_load_order_status_page.dart';
import '../picking_load_streets_page/picking_load_streets_page.dart';
import 'cubit/picking_load_cubit.dart';
import 'widgets/load_card_widget.dart';

class PickingLoadListPage extends ConsumerStatefulWidget {
  const PickingLoadListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PickingLoadListPageState();
}

class _PickingLoadListPageState extends ConsumerState<PickingLoadListPage> {
  bool isPending = true;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PickingLoadCubit(ref.read(pickingRouteRepositoryProvider)),
      child: BlocBuilder<PickingLoadCubit, PickingLoadState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Cargas"),
              actions: [
                IconButton(
                    onPressed: () {
                      context
                          .read<PickingLoadCubit>()
                          .fetchPickingLoads(isPending);
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<PickingLoadCubit, PickingLoadState>(
                  builder: (context, state) {
                    if (state is PickingLoadLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is PickingLoadError) {
                      return Center(
                        child: Text(state.error.error),
                      );
                    }

                    if (state is PickingLoadLoaded) {
                      final data = state.loads;

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text("Pendentes Separação"),
                              const SizedBox(
                                width: 15,
                              ),
                              Switch(
                                value: isPending,
                                activeColor: Colors.green,
                                inactiveTrackColor: Colors.grey,
                                onChanged: (bool value) {
                                  // This is called when the user toggles the switch.
                                  setState(() {
                                    isPending = value;
                                  });
                                  context
                                      .read<PickingLoadCubit>()
                                      .fetchPickingLoads(isPending);
                                },
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return LoadCardWidget(
                                  load: data[index],
                                  onSearch: () {
                                    final cubit =
                                        context.read<PickingLoadCubit>();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PickingLoadOrderStatusPage(
                                          cubit: cubit,
                                          load: data[index].codCarga,
                                          isPending: isPending,
                                        ),
                                      ),
                                    );
                                  },
                                  onTap: () {
                                    final cubit =
                                        context.read<PickingLoadCubit>();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PickingLoadStreetsPage(
                                          cubit: cubit,
                                          load: data[index].codCarga,
                                          isPending: isPending,
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
