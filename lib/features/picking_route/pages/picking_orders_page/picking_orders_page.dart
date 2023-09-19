import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_estoque/features/picking/pages/picking_list/widgets/picking_card_widget.dart';
import 'package:nexus_estoque/features/picking_route/pages/picking_order_products_page/picking_orders_products_page.dart';
import 'package:nexus_estoque/features/picking_route/pages/picking_routes_page/cubit/picking_routes_cubit.dart';

class PickingOrdersPage extends StatelessWidget {
  const PickingOrdersPage({super.key, required this.cubit});
  final PickingRoutesCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocListener<PickingRoutesCubit, PickingRoutesState>(
        listener: (context, state) {
          if (state is PickingRoutesInitial) {
            Navigator.pop(context);
          }

          if (state is PickingRoutesError) {
            Navigator.pop(context);
          }

          if (state is PickingRoutesLoaded) {
            if (state.shippingSelected == null) {
              Navigator.pop(context);
            }
          }
        },
        child: BlocBuilder<PickingRoutesCubit, PickingRoutesState>(
          builder: (context, state) {
            if (state is PickingRoutesLoaded) {
              if (state.shippingSelected == null) {
                return const Text("Não encontrado!");
              }
              final orders = state.shippingSelected!.pedidos;
              return Scaffold(
                appBar: AppBar(
                  title: Text("Carga: ${state.shippingSelected!.codCarga}"),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return PickingCard(
                        data: orders[index],
                        onTap: () async {
                          cubit.setPickingOrder(orders[index]);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PickingOrderProductsPage(
                                cubit: cubit,
                                pedido: orders[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            }

            if (state is PickingRoutesLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return const Scaffold(
              body: Center(
                child: Text("Erro Picking Orders Page"),
              ),
            );
          },
        ),
      ),
    );
  }
}
