import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_estoque/features/picking/data/model/picking_order_model.dart';
import 'package:nexus_estoque/features/picking/pages/picking_list/cubit/picking_cubit.dart';
import 'package:nexus_estoque/features/picking/pages/picking_list/widgets/picking_card_widget.dart';
import 'package:nexus_estoque/features/picking/pages/picking_products_list/picking_products_list_page.dart';

class PickingPage extends StatefulWidget {
  const PickingPage({super.key});

  @override
  State<PickingPage> createState() => _PickingPageState();
}

class _PickingPageState extends State<PickingPage> {
  final TextEditingController controller = TextEditingController();
  List<PickingOrder> listProductAddress = [];
  List<PickingOrder> filterList = [];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    context.read<PickingCubitCubit>().fetchPickingList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Separacao Pedidos"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<PickingCubitCubit>().fetchPickingList();
        },
        child: Padding(
          //padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          padding: const EdgeInsets.all(0),
          child: Container(
            padding: const EdgeInsets.all(10),
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
                    label: Text("Pesquisar Pedido/Cliente"),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<PickingCubitCubit, PickingCubitState>(
                    builder: (context, state) {
                      if (state is PickingCubitInitial) {
                        return const Center(
                          child: Text("State Initital"),
                        );
                      }
                      if (state is PickingCubitLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is PickingCubitError) {
                        return Center(
                          child: Text(state.failure.error),
                        );
                      }
                      if (state is PickingCubiLoaded) {
                        listProductAddress = state.pickingList;
                        filterList = filter(controller.text);

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
                            return PickingCard(
                              data: filterList[index],
                              onTap: () async {
                                /*      context.push(
                                    '/separacao/itens/${filterList[index].pedido}'); */

                                final cubit = context.read<PickingCubitCubit>();
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PickingProductPage(
                                    cubit: cubit,
                                    pedido: filterList[index].pedido,
                                  ),
                                ));
                                //PickingProductPage
                              },
                            );
                          },
                        );
                      }
                      return const Text("Error State");
                    },
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

  List<PickingOrder> filter(String search) {
    return listProductAddress.where((element) {
      if (element.pedido.toUpperCase().contains(search.toUpperCase())) {
        return true;
      }

      if (element.codCliente.toUpperCase().contains(search.toUpperCase())) {
        return true;
      }

      if (element.descCliente.toUpperCase().contains(search.toUpperCase())) {
        return true;
      }

      return false;
    }).toList();
  }
}
