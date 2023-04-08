import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/picking_route/data/repositories/picking_route_repository.dart';
import 'package:nexus_estoque/features/picking_route/pages/picking_routes_page/widgets/picking_routes_list_widget.dart';

import 'cubit/picking_routes_cubit.dart';

class PickingRoutesListPage extends ConsumerStatefulWidget {
  const PickingRoutesListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PickingRoutesListPageState();
}

class _PickingRoutesListPageState extends ConsumerState<PickingRoutesListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rotas")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocProvider(
            create: (context) =>
                PickingRoutesCubit(ref.read(pickingRouteRepositoryProvider)),
            child: BlocBuilder<PickingRoutesCubit, PickingRoutesState>(
              builder: (context, state) {
                if (state is PickingRoutesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is PickingRoutesError) {
                  return Center(
                    child: Text(state.error.error),
                  );
                }
                if (state is PickingRoutesLoaded) {
                  return PickingRoutesList(
                    pickingRoutes: state.pickingRoutes,
                  );
                }

                return const Text("Initial");
              },
            ),
          ),
        ),
      ),
    );
  }
}
