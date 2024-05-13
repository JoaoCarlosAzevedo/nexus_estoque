import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../picking_load/pages/picking_load_list_page/cubit/picking_load_cubit.dart';
import '../../../picking_load/pages/picking_load_order_status_page/picking_load_order_status_page.dart';
import '../../../picking_route/data/repositories/picking_route_repository.dart';
import '../picking_load_streets_list_page/picking_load_v2_streets_page.dart';
import 'widgets/load_card_widget.dart';

class PickingLoadListPagev2 extends ConsumerStatefulWidget {
  const PickingLoadListPagev2({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PickingLoadListPagev2State();
}

class _PickingLoadListPagev2State extends ConsumerState<PickingLoadListPagev2> {
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
                      context.read<PickingLoadCubit>().fetchPickingLoads();
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

                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return LoadCardWidget(
                            load: data[index],
                            onSearch: () {
                              final cubit = context.read<PickingLoadCubit>();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PickingLoadOrderStatusPage(
                                    cubit: cubit,
                                    load: data[index].codCarga,
                                  ),
                                ),
                              );
                            },
                            onTap: () {
                              final cubit = context.read<PickingLoadCubit>();

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
