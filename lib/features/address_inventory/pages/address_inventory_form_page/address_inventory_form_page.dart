import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/features/searches/products/data/model/product_model.dart';
import '../../../../core/features/searches/products/provider/remote_product_provider.dart';
import '../../../../core/mixins/validation_mixin.dart';
import '../../../address_balance/data/model/address_balance_model.dart';
import 'state/address_inventory_provider.dart';
import 'widgets/address_warehouse_card.dart';
import 'widgets/inventory_quantity_input.dart';

class AddressInventoryFormPage extends ConsumerStatefulWidget {
  const AddressInventoryFormPage(
      {required this.address, required this.doc, super.key});
  final AddressBalanceModel address;
  final String doc;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressInventoryFormPageState();
}

class _AddressInventoryFormPageState
    extends ConsumerState<AddressInventoryFormPage> with ValidationMixi {
  final TextEditingController productController = TextEditingController();
  final FocusNode focus = FocusNode();
  List<ProductModel> productsInventory = [];
  late List<ProductModel> listWatch = [];

  void hideKeyboard() {
    Future.delayed(
      const Duration(milliseconds: 100),
      () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
    );
  }

  @override
  void initState() {
    hideKeyboard();
    super.initState();

    //executa no final do build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addressInventoryProvider.notifier).setDoc(widget.doc);
      ref
          .read(addressInventoryProvider.notifier)
          .setWarehouse(widget.address.armazem);
      ref
          .read(addressInventoryProvider.notifier)
          .setAddress(widget.address.codEndereco);
    });
  }

  @override
  void dispose() {
    focus.dispose();
    productController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AddressInventoryState state = ref.watch(addressInventoryProvider);
    ref.listen(addressInventoryProvider, (previous, current) {
      if (current.status == StateEnum.error) {
        AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                desc: 'Erro na API',
                btnOkOnPress: () {},
                btnOkColor: Theme.of(context).primaryColor)
            .show();
      }
      if (current.status == StateEnum.success) {
        context.pop();
      }
    });

    productsInventory = state.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contagem Produtos"),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Documento: ${state.doc}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              AddressWarehouseCard(
                address: widget.address,
              ),
              const Divider(),
              if (state.status != StateEnum.loading)
                TextFormField(
                  autofocus: true,
                  focusNode: focus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (e) {
                    getProduct(e);
                    productController.clear();
                    focus.requestFocus();
                    hideKeyboard();
                  },
                  validator: isNotEmpty,
                  controller: productController,
                  decoration: const InputDecoration(
                    label: Text("Produto"),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.qr_code),
                  ),
                ),
              state.status == StateEnum.loading
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: productsInventory.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () async {
                              double? newQuantity =
                                  await InventoryQuantityModal.show(
                                      context,
                                      productsInventory[index],
                                      productsInventory[index].qtdInvet);
                              if (newQuantity != null) {
                                ref
                                    .read(addressInventoryProvider.notifier)
                                    .changeQuantity(
                                        productsInventory[index], newQuantity);
                              }
                            },
                            onLongPress: () {
                              ref
                                  .read(addressInventoryProvider.notifier)
                                  .removeProduct(productsInventory[index]);
                            },
                            title: Text(
                              '${productsInventory[index].codigo} - ${productsInventory[index].codigoBarras}',
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(productsInventory[index].descricao),
                                if (productsInventory[index].error.isNotEmpty)
                                  Text(
                                    productsInventory[index].error,
                                    style: const TextStyle(color: Colors.red),
                                  )
                              ],
                            ),
                            trailing: Text(
                              'Qtd: ${productsInventory[index].qtdInvet}',
                              style: const TextStyle(color: Colors.green),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Confirmar"),
        onPressed: () {
          ref.read(addressInventoryProvider.notifier).postInventory();
        },
        icon: const Icon(Icons.check),
        backgroundColor: Colors.green,
      ),
    );
  }

  void getProduct(String product) {
    if (listWatch.isEmpty) {
      listWatch = ref.read(remoteProductProvider).maybeWhen(
            data: (data) => data,
            orElse: () => [],
          );
    }

    if (product.trim().isEmpty) {
      return;
    }

    if (listWatch.isNotEmpty) {
      var selectedProduct = listWatch.firstWhere(
        (element) {
          if (element.codigo.toUpperCase().trim() ==
              product.toUpperCase().trim()) {
            return true;
          }

          if (element.codigoBarras
              .toUpperCase()
              .contains(product.toUpperCase())) {
            return true;
          }

          return false;
        },
        orElse: () => ProductModel(
            descricao: '',
            localPadrao: '',
            lote: '',
            codigoBarras: '',
            localizacao: '',
            tipo: '',
            saldoAtual: 0.0,
            qtdInvet: 0.0,
            um: '',
            codigo: '',
            error: ''),
      );

      if (selectedProduct.codigo.isNotEmpty) {
        ref.read(addressInventoryProvider.notifier).addProduct(selectedProduct);
      } else {
        AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                desc: 'Produto não encontrado!',
                btnOkOnPress: () {},
                btnOkColor: Theme.of(context).primaryColor)
            .show();
      }
    }
  }
}
