import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:nexus_estoque/features/inventory/pages/inventory_product_page.dart';

import '../../../../core/mixins/validation_mixin.dart';

import '../../../../core/widgets/form_input_no_keyboard_search_widget.dart';
import '../../../core/features/product_balance/data/model/product_balance_model.dart';
import '../../../core/features/searches/products/data/model/product_model.dart';
import '../../../core/features/searches/products/pages/products_search_page.dart';
import '../../../core/features/searches/products/provider/remote_product_provider.dart';
import '../../../core/features/searches/warehouses/pages/warehouse_search_page.dart';
import '../../../core/widgets/form_input_search_widget.dart';
import '../../address_balance/data/model/address_balance_model.dart';
import '../../address_balance/pages/address_balance_page/cubit/address_balance_cubit.dart';
import '../../address_inventory/data/repositories/inventory_repository.dart';
import '../../address_inventory/pages/address_inventory_form_page/state/address_inventory_provider.dart';
import '../../address_inventory/pages/address_inventory_form_page/widgets/inventory_quantity_input.dart';
import '../../address_inventory/pages/address_inventory_page/widgets/products_status_widget.dart';
import '../../auth/providers/login_controller_provider.dart';
import '../../auth/providers/login_state.dart';
import '../../transaction/pages/transaction_form_page/widgets/transaction_form.dart';
import '../state/inventory_provider.dart';

const List<String> list = <String>['1', '2', '3', '4'];

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage>
    with ValidationMixi {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController warehouseController = TextEditingController();

  final FocusNode addressFocus = FocusNode();
  List<AddressBalanceModel> listBalances = [];
  late AddressBalanceCubit cubit;
  final DateFormat formatter = DateFormat('yyyyMMdd');
  List<ProductModel> productsInventory = [];
  late List<ProductModel> listWatch = [];

  String dropdownValue = list.first;
  String doc = "";
  String user = "";

  @override
  void dispose() {
    addressController.dispose();
    addressFocus.dispose();
    warehouseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authUser = ref.read(loginControllerProvider);

    if (authUser is LoginStateSuccess) {
      user = authUser.user.id;
    }

    final docProvider = ref.watch(remoteGetInventoryDocProvider(user));
    InventoryState state = ref.watch(inventoryProvider);

    ref.listen(inventoryProvider, (previous, current) {
      if (current.status == StateEnum.error) {
        AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                desc: 'Erro na API',
                btnOkOnPress: () {},
                btnOkColor: Theme.of(context).primaryColor)
            .show();

        ref.read(inventoryProvider.notifier).resetError();
      }
      if (current.status == StateEnum.success) {
        //context.pop();
        ref.read(inventoryProvider.notifier).resetState();
      }
    });

    productsInventory = state.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventário"),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            docProvider.when(
              skipLoadingOnRefresh: false,
              data: (data) {
                doc = data;

                return Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contagem: ${doc.substring(doc.length - 1)}',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        Text(
                          'Documento: $data',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    IconButton(
                      onPressed: () {
                        ref.invalidate(remoteGetInventoryDocProvider);
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                );
              },
              error: ((error, stackTrace) => Row(
                    children: [
                      const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(error.toString()),
                      IconButton(
                        onPressed: () {
                          ref.invalidate(remoteGetInventoryDocProvider);
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  )),
              loading: () => Row(
                children: [
                  Text(
                    "Documento: ",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  ),
                ],
              ),
            ),
            const ProductsStatusWidget(),
            InputSearchWidget(
              label: "Armazem",
              autoFocus: false,
              controller: warehouseController,
              validator: isNotEmpty,
              onPressed: () async {
                final value = await WarehouseSearchModal.show(
                  context,
                  ProductBalanceModel(
                      descricao: '',
                      localPadrao: '',
                      codigoBarras: '',
                      lote: '',
                      localizacao: '',
                      tipo: '',
                      uM: '',
                      armazem: [],
                      codigo: '',
                      codigoBarras2: ''),
                  Tm.entrada,
                );
                warehouseController.text = value;
                addressFocus.requestFocus();
              },
            ),
            const Divider(),
            NoKeyboardTextSearchForm(
              label: 'Produto',
              autoFocus: true,
              focusNode: addressFocus,
              onSubmitted: (e) {
                getProduct(e);
                addressController.clear();
                addressFocus.requestFocus();
              },
              validator: isNotEmpty,
              controller: addressController,
              prefixIcon: IconButton(
                onPressed: () async {
                  //productSearchPage();
                  addressController.text =
                      await ProductSearchModal.show(context, false);
                  getProduct(addressController.text);
                  addressController.clear();
                  addressFocus.requestFocus();
                },
                icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
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
                        return Card(
                          child: ListTile(
                            onTap: () async {
                              if (productsInventory[index].codigo.isNotEmpty) {
                                double? newQuantity =
                                    await InventoryQuantityModal.show(
                                        context,
                                        productsInventory[index],
                                        productsInventory[index].qtdInvet);
                                if (newQuantity != null) {
                                  ref
                                      .read(inventoryProvider.notifier)
                                      .changeQuantity(productsInventory[index],
                                          newQuantity);
                                }
                              }
                            },
                            onLongPress: () {
                              ref
                                  .read(inventoryProvider.notifier)
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
                            leading: IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductInventoryListPage(
                                            product:
                                                productsInventory[index].codigo,
                                            doc: doc,
                                          )),
                                );
                              },
                            ),
                            trailing: Text(
                              'Qtd: ${productsInventory[index].qtdInvet}',
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: state.status == StateEnum.loading
          ? null
          : FloatingActionButton.extended(
              label: const Text("Confirmar"),
              onPressed: () {
                ref
                    .read(inventoryProvider.notifier)
                    .postInventory(warehouseController.text, doc);
              },
              icon: const Icon(Icons.check),
              backgroundColor: Colors.green,
            ),
    );
  }

  void hideKeyboard() async {
    await Future.delayed(
      const Duration(milliseconds: 100),
      () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
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
          if (element.codigoBarras2
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
            codigoBarras2: '',
            localizacao: '',
            tipo: '',
            saldoAtual: 0.0,
            qtdInvet: 0.0,
            fator: 0.0,
            um: '',
            codigo: '',
            error: ''),
      );

      if (selectedProduct.codigo.isNotEmpty) {
        ref.read(inventoryProvider.notifier).addProduct(selectedProduct);
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
