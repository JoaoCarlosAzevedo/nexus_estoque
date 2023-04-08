import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_estoque/features/picking_route/data/model/picking_route_model.dart';
import 'package:nexus_estoque/features/picking_route/pages/picking_routes_page/cubit/picking_routes_cubit.dart';
import 'package:nexus_estoque/features/picking_route/pages/picking_shipping_page/picking_shipping_page.dart';

class PickingRoutesList extends StatelessWidget {
  const PickingRoutesList({super.key, required this.pickingRoutes});
  final List<PickingRouteModel> pickingRoutes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pickingRoutes.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            onTap: () {
              context
                  .read<PickingRoutesCubit>()
                  .setRoute(pickingRoutes[index].codRota);
              final cubit = context.read<PickingRoutesCubit>();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PickingShippingPage(
                    cubit: cubit,
                  ),
                ),
              );
            },
            title: Text(pickingRoutes[index].codRota),
            subtitle: Text(pickingRoutes[index].descRota),
            trailing: Text("Cargas: ${pickingRoutes[index].cargas.length}"),
          ),
        );
      },
    );
  }
}
