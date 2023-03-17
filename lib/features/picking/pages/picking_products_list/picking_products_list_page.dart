import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_estoque/features/picking/data/model/picking_model.dart';
import 'package:nexus_estoque/features/picking/data/model/picking_order_model.dart';
import 'package:nexus_estoque/features/picking/pages/picking_form/picking_form_modal.dart';
import 'package:nexus_estoque/features/picking/pages/picking_list/cubit/picking_cubit.dart';
import 'package:nexus_estoque/features/picking/pages/picking_list/widgets/picking_card_widget.dart';
import 'package:nexus_estoque/features/picking/pages/picking_products_list/widgets/picking_product_card_wigdet.dart';

class PickingProductPage extends StatefulWidget {
  const PickingProductPage(
      {super.key, required this.cubit, required this.pedido});
  final PickingCubitCubit cubit;
  final String pedido;

  @override
  State<PickingProductPage> createState() => _PickingProductPageState();
}

class _PickingProductPageState extends State<PickingProductPage> {
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
        title: Text("Pedido: ${widget.pedido}"),
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
                          final aux = state.pickingList.firstWhereOrNull(
                            (element) => element.pedido == widget.pedido,
                          );
                          if (aux != null) {
                            listProductAddress = aux.itens;
                          } else {
                            listProductAddress = [];
                          }
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
                              return PickingProductCard(
                                data: filterList[index],
                                onTap: () async {
                                  final result = await PickingFormModal.show(
                                      context, filterList[index]);

                                  if (result == "ok") {
                                    context
                                        .read<PickingCubitCubit>()
                                        .fetchPickingList();
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
