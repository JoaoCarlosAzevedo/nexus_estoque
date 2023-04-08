import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_estoque/features/picking_route/pages/picking_routes_page/cubit/picking_routes_cubit.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class PickingShippingPage extends StatelessWidget {
  const PickingShippingPage({super.key, required this.cubit});
  final PickingRoutesCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<PickingRoutesCubit, PickingRoutesState>(
        builder: (context, state) {
          if (state is PickingRoutesLoaded) {
            final shippingList = state.pickingRoutes.firstWhereOrNull(
              (element) => element.codRota == state.routeSelected,
            );

            if (shippingList == null) {
              return const Text("N encontrei");
            }
            return Scaffold(
              appBar: AppBar(
                title: Text("${state.routeSelected} - Cargas"),
              ),
              body: ListView.builder(
                itemCount: shippingList!.cargas.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        cubit.fetchPickingRoutes();
                      },
                      title:
                          Text("Carga: ${shippingList.cargas[index].codCarga}"),
                      subtitle: Text(shippingList.cargas[index].descTransp),
                      trailing: Text(
                          "Entregas: ${shippingList.cargas[index].qtdEntregas}"),
                    ),
                  );
                },
              ),
            );
          }
          return const Text("Vish");
        },
      ),
    );
  }
}
