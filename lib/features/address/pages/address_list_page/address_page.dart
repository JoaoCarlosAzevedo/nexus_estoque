import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_estoque/features/address/data/model/product_address_model.dart';
import 'package:nexus_estoque/features/address/pages/address_list_page/cubit/product_address_cubit.dart';
import 'package:nexus_estoque/features/address/pages/address_list_page/cubit/product_address_state.dart';

class AddressPage extends ConsumerStatefulWidget {
  const AddressPage({super.key});

  @override
  ConsumerState<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends ConsumerState<AddressPage> {
  List<ProductAddressModel> listProductAddress = [];
  List<ProductAddressModel> filterList = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 500),
      () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
    );
  }

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
        title: const Text("Endereçamento"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProductAddressCubit>().fetchProductAddress();
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
                    label: Text("Pesquisar NF / Produto"),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ProductAddressCubit, ProductAddressState>(
                    builder: (context, state) {
                      if (state is ProductAddresInitial) {
                        return const Center(
                          child: Text("State Initital"),
                        );
                      }
                      if (state is ProductAddressLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is ProductAddressError) {
                        return Center(
                          child: Text(state.failure.error),
                        );
                      }
                      if (state is ProductAddressLoaded) {
                        listProductAddress = state.productAddresList;
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
                            return AddressCard(
                              data: filterList[index],
                              onTap: () {
                                context.push('/enderecar/form/',
                                    extra: filterList[index]);
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

  List<ProductAddressModel> filter(String search) {
    return listProductAddress.where((element) {
      if (element.notafiscal.toUpperCase().contains(search.toUpperCase())) {
        return true;
      }

      if (element.codigo.toUpperCase().contains(search.toUpperCase())) {
        return true;
      }

      if (element.descricao.toUpperCase().contains(search.toUpperCase())) {
        return true;
      }

      if (element.lote.toUpperCase().contains(search.toUpperCase())) {
        return true;
      }

      if (search.trim().length >= 44) {
        if (element.chave.toUpperCase().contains(search.trim().toUpperCase())) {
          return true;
        }
      }

      return false;
    }).toList();
  }
}

class AddressCard extends StatelessWidget {
  final ProductAddressModel data;
  final GestureTapCallback onTap;

  const AddressCard({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: onTap,
          title: Text(
            data.descricao,
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Codigo",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          data.codigo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Saldo",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          "${data.saldo}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Fornecedor",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.fornecedor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              invoiceOrBatch(data.notafiscal, data.lote),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Armazem",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          data.armazem,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }

  String invoiceOrBatch(String invoice, String batch) {
    if (invoice.isEmpty && batch.isEmpty) {
      return '';
    }

    if (invoice.isEmpty) {
      return "Lote: $batch";
    }

    if (batch.isEmpty) {
      return "NF: $invoice";
    }

    return '';
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => true;
}
