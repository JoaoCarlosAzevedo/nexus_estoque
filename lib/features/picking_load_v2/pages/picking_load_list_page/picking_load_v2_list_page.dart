import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/picking_load_v2/pages/picking_load_list_page/cubit/picking_loadv2_cubit.dart';

import '../../data/model/shippingv2_model.dart';
import '../../data/repositories/pickingv2_repository.dart';
import 'widgets/picking_load_v2_list_widget.dart';

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
                      String load = "";

                      if (state.load.isNotEmpty) {
                        load = state.load;
                      }

                      List<Shippingv2Model> data = state.loads;

                      return PickingLoadV2ListWidget(
                        data: data,
                        load: load,
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
