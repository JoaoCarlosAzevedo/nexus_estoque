import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../picking_route/data/repositories/picking_route_repository.dart';
import '../picking_load_order_status_page/picking_load_order_status_page.dart';
import '../picking_load_streets_page/picking_load_streets_page.dart';
import '../picking_pallet_obs/cubit/picking_pallet_obs_cubit.dart';
import '../picking_pallet_obs/widgets/pallet_obs_layout.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              PickingLoadCubit(ref.read(pickingRouteRepositoryProvider)),
        ),
        BlocProvider(
          create: (context) =>
              PickingPalletObsCubit(ref.read(pickingRouteRepositoryProvider)),
        ),
      ],
      child: BlocBuilder<PickingLoadCubit, PickingLoadState>(
        builder: (context, loadState) {
          return BlocBuilder<PickingPalletObsCubit, PickingPalletObsState>(
            builder: (context, obsState) {
              final hasObsPedLoad = loadState is PickingLoadLoaded &&
                  loadState.loads.any((load) => load.isObsPed);
              final enablePanel = obsState.items.isNotEmpty || hasObsPedLoad;

              return Scaffold(
                appBar: AppBar(
                  title: const Text("Cargas"),
                  actions: [
                    PalletObsAppBarAction(enablePanel: enablePanel),
                    IconButton(
                      onPressed: () {
                        context
                            .read<PickingLoadCubit>()
                            .fetchPickingLoads(isPending);
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0),
                    child: _buildBody(context, loadState, enablePanel),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    PickingLoadState loadState,
    bool enablePanel,
  ) {
    if (loadState is PickingLoadLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (loadState is PickingLoadError) {
      return Center(
        child: Text(loadState.error.error),
      );
    }

    if (loadState is PickingLoadLoaded) {
      final data = loadState.loads;

      final content = Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("Pendentes Separação"),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  width: 40,
                  height: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: isPending,
                      activeColor: Colors.green,
                      inactiveTrackColor: Colors.grey,
                      onChanged: (bool value) {
                        setState(() {
                          isPending = value;
                        });
                        context
                            .read<PickingLoadCubit>()
                            .fetchPickingLoads(isPending);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return LoadCardWidget(
                  load: data[index],
                  onSearch: () {
                    final cubit = context.read<PickingLoadCubit>();
                    final palletObsCubit =
                        context.read<PickingPalletObsCubit>();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(value: cubit),
                            BlocProvider.value(value: palletObsCubit),
                          ],
                          child: PickingLoadOrderStatusPage(
                            cubit: cubit,
                            load: data[index].codCarga,
                            isPending: isPending,
                          ),
                        ),
                      ),
                    );
                  },
                  onTap: () {
                    final cubit = context.read<PickingLoadCubit>();
                    final palletObsCubit =
                        context.read<PickingPalletObsCubit>();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(value: cubit),
                            BlocProvider.value(value: palletObsCubit),
                          ],
                          child: PickingLoadStreetsPage(
                            cubit: cubit,
                            load: data[index].codCarga,
                            isPending: isPending,
                          ),
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

      return PalletObsLayout(
        enablePanel: enablePanel,
        child: content,
      );
    }

    return const Text("Initial");
  }
}
