import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_estoque/features/picking_route/pages/picking_orders_page/picking_orders_page.dart';
import 'package:nexus_estoque/features/picking_route/pages/picking_routes_page/cubit/picking_routes_cubit.dart';

class PickingShippingPage extends StatelessWidget {
  const PickingShippingPage({super.key, required this.cubit});
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
            if (state.routeSelected == null) {
              Navigator.pop(context);
            }
          }
        },
        child: BlocBuilder<PickingRoutesCubit, PickingRoutesState>(
          builder: (context, state) {
            if (state is PickingRoutesLoaded) {
              if (state.routeSelected == null) {
                return const Text("Nao encontrado!");
              }
              final shippingList = state.routeSelected!.cargas;
              return Scaffold(
                appBar: AppBar(
                  title: Text("Rota: ${state.routeSelected!.codRota}"),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: shippingList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            cubit.setShipping(shippingList[index]);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PickingOrdersPage(
                                  cubit: cubit,
                                ),
                              ),
                            );
                          },
                          title: Text(
                            "Carga ${shippingList[index].codCarga}",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Transportadora",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                          Text(
                                            shippingList[index].descTransp,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Qtd. Entregaas",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                          Text(
                                            "${shippingList[index].qtdEntregas}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Peso Carga",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${shippingList[index].peso}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Qtd. Pedidos",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                          Text(
                                            "${shippingList[index].pedidos.length}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
                child: Text("Error Picking Shipping Page"),
              ),
            );
          },
        ),
      ),
    );
  }
}
