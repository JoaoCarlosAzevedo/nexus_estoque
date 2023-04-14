import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_estoque/features/picking/data/model/picking_model.dart';
import 'package:nexus_estoque/features/picking/data/model/picking_order_model.dart';
import 'package:nexus_estoque/features/picking/pages/picking_form/picking_form_modal.dart';
import 'package:nexus_estoque/features/picking/pages/picking_products_list/widgets/picking_product_card_wigdet.dart';
import 'package:nexus_estoque/features/picking_route/pages/picking_routes_page/cubit/picking_routes_cubit.dart';

class PickingOrderProductsPage extends StatefulWidget {
  const PickingOrderProductsPage(
      {super.key, required this.cubit, required this.pedido});
  final PickingRoutesCubit cubit;
  final PickingOrder pedido;

  @override
  State<PickingOrderProductsPage> createState() =>
      _PickingOrderProductsPageState();
}

class _PickingOrderProductsPageState extends State<PickingOrderProductsPage> {
  final TextEditingController controller = TextEditingController();
  List<PickingModel> listProductAddress = [];
  List<PickingModel> filterList = [];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Pedido: ${widget.pedido.pedido}"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            padding: const EdgeInsets.all(10),
            color: Theme.of(context).selectedRowColor,
            child: Column(
              children: [
                TextField(
                  showCursor: true,
                  autofocus: true,
                  controller: controller,
                  onChanged: (e) {
                    setState(() {});
                    //search(e);
                  },
                  onSubmitted: (e) {
                    //search(e);
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    label: Text("Pesquisar Ped./Cod/Endereco"),
                  ),
                ),
                Expanded(
                  child: BlocProvider.value(
                    value: widget.cubit,
                    child: BlocListener<PickingRoutesCubit, PickingRoutesState>(
                      listener: (context, state) {
                        if (state is PickingRoutesInitial) {
                          Navigator.pop(context);
                        }

                        if (state is PickingRoutesError) {
                          Navigator.pop(context);
                        }

                        if (state is PickingRoutesLoaded) {
                          if (state.pickingOrderSelected == null) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      child:
                          BlocBuilder<PickingRoutesCubit, PickingRoutesState>(
                        builder: (context, state) {
                          if (state is PickingRoutesLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is PickingRoutesLoaded) {
                            if (state.pickingOrderSelected == null) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final aux = state.pickingOrderSelected!.itens;
                            listProductAddress = aux;

                            filterList = filter(controller.text);

                            filterList.sort((a, b) =>
                                a.descEndereco.compareTo(b.descEndereco));

                            if (filterList.isEmpty) {
                              return const Center(
                                child: Text("Nenhum registro encontrado."),
                              );
                            }
                            return ListView.builder(
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              itemCount: filterList.length,
                              itemBuilder: (context, index) {
                                return PickingProductCard(
                                  data: filterList[index],
                                  onTap: () async {
                                    final result = await PickingFormModal.show(
                                        context, filterList[index]);
                                    if (result == "ok") {
                                      widget.cubit.fetchPickingRoutes();
                                    }
                                  },
                                );
                              },
                            );
                          }
                          return const Text("Error State");
                        },
                      ),
                    ),
                  ),
                )
                //Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PickingModel> filter(String search) {
    return listProductAddress.where((element) {
      if (element.codigo.toUpperCase().contains(search.toUpperCase())) {
        return true;
      }

      if (element.codEndereco.toUpperCase().contains(search.toUpperCase())) {
        return true;
      }

      if (element.descEndereco.toUpperCase().contains(search.toUpperCase())) {
        return true;
      }

      if (element.pedido.toUpperCase().contains(search.toUpperCase())) {
        return true;
      }

      if (element.codigobarras.toUpperCase().contains(search.toUpperCase())) {
        return true;
      }

      return false;
    }).toList();
  }
}
