import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_estoque/features/address_inventory/pages/address_inventory_form_page/widgets/inventory_quantity_input.dart';

import '../../../../core/features/searches/batches/pages/batches_search_page.dart';
import '../../../../core/features/searches/products/data/model/product_model.dart';
import '../../../../core/features/searches/products/pages/products_search_page.dart';
import '../../../../core/features/searches/products/provider/remote_product_provider.dart';
import '../../../../core/mixins/validation_mixin.dart';
import '../../../../core/widgets/form_input_no_keyboard_search_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/datetime_formatter.dart';
import '../../../address_balance/data/model/address_balance_model.dart';
import '../../data/model/inventory_model.dart';
import '../../data/repositories/inventory_repository.dart';
import '../address_inventory_list/widgets/delete_icon_widget.dart';
import 'state/address_inventory_provider.dart';
import 'widgets/address_warehouse_card.dart';
import 'widgets/dun_quantity_input.dart';

class AddressInventoryFormPage extends ConsumerStatefulWidget {
  const AddressInventoryFormPage(
      {required this.address,
      required this.doc,
      required this.data,
      super.key});
  final AddressBalanceModel address;
  final String doc;
  final List<InventoryModel> data;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressInventoryFormPageState();
}

class _AddressInventoryFormPageState
    extends ConsumerState<AddressInventoryFormPage> with ValidationMixi {
  final TextEditingController productController = TextEditingController();
  final TextEditingController loteController = TextEditingController();
  final FocusNode focus = FocusNode();
  final FocusNode loteFocus = FocusNode();
  List<ProductModel> productsInventory = [];
  late List<ProductModel> listWatch = [];
  late List<InventoryModel> inventoryData = [];
  bool isLote = false;
  late ProductModel prodInv;
  String vencLote = "";
  bool isValidDateLote = false;

  @override
  void initState() {
    //hideKeyboard();
    super.initState();

    //executa no final do build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addressInventoryProvider.notifier).setDoc(widget.doc);

      if (widget.address.prdInvent) {
        if (widget.address.codProd.trim().isNotEmpty) {
          ref.read(addressInventoryProvider.notifier).addProduct(
              ProductModel(
                  descricao: widget.address.descProd,
                  localPadrao: widget.address.armazem,
                  lote: '',
                  codigoBarras: '',
                  codigoBarras2: '',
                  localizacao: '',
                  tipo: '',
                  saldoAtual: 0.0,
                  qtdInvet: 0.0,
                  fator: 0.0,
                  um: '',
                  codigo: widget.address.codProd,
                  error: ''),
              0);
        }
      }
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
    loteFocus.dispose();
    productController.dispose();
    loteController.dispose();
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
        /*   if (isLote) {
          ref.invalidate(remoteGetInventoryProvider);
        } else {
          context.pop();
        } */
      }
    });

    productsInventory = state.products;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: state.doc.isEmpty
              ? const Text("Contagem")
              : Text("Contagem ${state.doc.substring(state.doc.length - 1)}"),
          actions: [
            IconButton(
                onPressed: () {
                  ref.invalidate(remoteGetInventoryProvider);
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Doc.: ${state.doc}",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    if (widget.address.codEndereco.isNotEmpty)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLote = false;
                          });
                          loteController.clear();
                          vencLote = "";
                          isValidDateLote = false;
                          ref
                              .read(addressInventoryProvider.notifier)
                              .addProduct(
                                  ProductModel(
                                      descricao: 'Contagem 0',
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
                                  1);
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.orange),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            "Cont. Vazia +",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ),
                  ],
                ),
                AddressWarehouseCard(
                  address: widget.address,
                ),
                if (state.status != StateEnum.loading)
                  SizedBox(
                    height: 50,
                    child: AppBar(
                      bottom: TabBar(
                        tabs: [
                          const Tab(
                            icon: Icon(Icons.content_paste_go),
                          ),
                          Tab(
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.content_paste_search,
                                ),
                                Text("(${widget.data.length})")
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Column(
                        children: [
                          const Divider(),
                          NoKeyboardTextSearchForm(
                            label: 'Produto',
                            autoFocus: true,
                            focusNode: focus,
                            onSubmitted: (e) {
                              getProduct(e);
                              productController.clear();
                              focus.requestFocus();
                            },
                            validator: isNotEmpty,
                            controller: productController,
                            prefixIcon: IconButton(
                              onPressed: () async {
                                //productSearchPage();
                                productController.text =
                                    await ProductSearchModal.show(
                                        context, false);
                                getProduct(productController.text);
                                productController.clear();
                                focus.requestFocus();
                              },
                              icon: const FaIcon(
                                  FontAwesomeIcons.magnifyingGlass),
                            ),
                          ),
                          if (isLote)
                            Row(
                              children: [
                                Expanded(
                                  child: NoKeyboardTextSearchForm(
                                    label: 'Lote',
                                    autoFocus: true,
                                    focusNode: loteFocus,
                                    onSubmitted: (e) {
                                      focus.requestFocus();
                                    },
                                    validator: isNotEmpty,
                                    controller: loteController,
                                    prefixIcon: IconButton(
                                      onPressed: () async {
                                        final value =
                                            await BatchSearchModalv2.show(
                                          context,
                                          prodInv.codigo,
                                          widget.address.armazem,
                                        );
                                        loteController.text = value;
                                        focus.requestFocus();
                                      },
                                      icon: const FaIcon(
                                          FontAwesomeIcons.magnifyingGlass),
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      final themeData = Theme.of(context);
                                      DateTime dataAtual = DateTime.now();
                                      final DateTime? pickedDate =
                                          await showDatePicker(
                                        builder: (context, Widget? child) =>
                                            Theme(
                                          data: themeData.copyWith(
                                            datePickerTheme:
                                                const DatePickerThemeData(
                                                    rangeSelectionBackgroundColor:
                                                        AppColors.background),
                                            appBarTheme: themeData.appBarTheme
                                                .copyWith(
                                                    backgroundColor:
                                                        Colors.blue,
                                                    iconTheme: themeData
                                                        .appBarTheme.iconTheme!
                                                        .copyWith(
                                                            color: Colors.red)),
                                            colorScheme:
                                                const ColorScheme.light(
                                              onPrimary: Colors.white,
                                              primary: Colors.grey,
                                              //surface: Colors.green,
                                            ),
                                          ),
                                          child: child!,
                                        ),
                                        context: context,
                                        initialDate: dataAtual,
                                        firstDate: DateTime(dataAtual.year - 5),
                                        lastDate: dataAtual,
                                      );
                                      if (pickedDate == null) return;

                                      setState(() {
                                        isValidDateLote = true;
                                        vencLote =
                                            datetimeToYYYYMMDD(pickedDate);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.calendar_month,
                                      color: isValidDateLote
                                          ? Colors.green
                                          : Colors.red,
                                    )),
                              ],
                            ),
                          if (isLote)
                            if (vencLote.isNotEmpty)
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                        "Dt. Fabr.: ${yyyymmddToDate(vencLote)}"),
                                  )),
                          state.status == StateEnum.loading
                              ? const Expanded(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Expanded(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: productsInventory.length,
                                          itemBuilder: (context, index) {
                                            return Card(
                                                child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: ListTile(
                                                    onTap: () async {
                                                      if (productsInventory[
                                                              index]
                                                          .codigo
                                                          .isNotEmpty) {
                                                        double? newQuantity =
                                                            await InventoryQuantityModal.show(
                                                                context,
                                                                productsInventory[
                                                                    index],
                                                                productsInventory[
                                                                        index]
                                                                    .qtdInvet);
                                                        if (newQuantity !=
                                                            null) {
                                                          ref
                                                              .read(
                                                                  addressInventoryProvider
                                                                      .notifier)
                                                              .changeQuantity(
                                                                  productsInventory[
                                                                      index],
                                                                  newQuantity);
                                                        }
                                                      }
                                                    },
                                                    onLongPress: () {
                                                      ref
                                                          .read(
                                                              addressInventoryProvider
                                                                  .notifier)
                                                          .removeProduct(
                                                              productsInventory[
                                                                  index]);
                                                    },
                                                    title: Text(
                                                      '${productsInventory[index].codigo} - ${productsInventory[index].codigoBarras}',
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(productsInventory[
                                                                index]
                                                            .descricao),
                                                        if (productsInventory[
                                                                index]
                                                            .error
                                                            .isNotEmpty)
                                                          Text(
                                                            productsInventory[
                                                                    index]
                                                                .error,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                          )
                                                      ],
                                                    ),
                                                    trailing: Text(
                                                      'Qtd: ${productsInventory[index].qtdInvet}',
                                                      style: const TextStyle(
                                                          color: Colors.green),
                                                    ),
                                                  ),
                                                ),
                                                if (productsInventory[index]
                                                    .isDun)
                                                  IconButton(
                                                    iconSize: 40,
                                                    onPressed: () async {
                                                      final double? qtd =
                                                          await DunQuantityModal
                                                              .show(
                                                                  context,
                                                                  productsInventory[
                                                                      index]);
                                                      if (qtd != null) {
                                                        ref
                                                            .read(
                                                                addressInventoryProvider
                                                                    .notifier)
                                                            .changeQuantity(
                                                                productsInventory[
                                                                    index],
                                                                qtd);
                                                      }
                                                    },
                                                    icon: const FaIcon(
                                                      FontAwesomeIcons
                                                          .calculator,
                                                      color:
                                                          Colors.orangeAccent,
                                                    ),
                                                  ),
                                              ],
                                            ));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),

                      // second tab bar viiew widget
                      Column(
                        children: [
                          const Divider(),
                          if (widget.data.isNotEmpty)
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text("Inventário Lançado"),
                            ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: widget.data.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    leading: InventoryDeleteIcon(
                                      recno: widget.data[index].recno,
                                      onSuccess: () {
                                        ref.invalidate(remoteGetInventoryProvider(
                                            '${widget.address.codEndereco}|${widget.doc}'));
                                      },
                                    ),
                                    title: Text(
                                      '${widget.data[index].descPro} - ${widget.data[index].codigoBarras}',
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.data[index].codPro),
                                        if (widget.data[index].lote
                                            .trim()
                                            .isNotEmpty)
                                          Text(
                                              'Lote: ${widget.data[index].lote}'),
                                        if (widget.data[index].dataLote
                                                .trim()
                                                .isNotEmpty &&
                                            widget.data[index].lote
                                                .trim()
                                                .isNotEmpty)
                                          Text(
                                              'Dt. Venc.: ${widget.data[index].dataLote}'),
                                      ],
                                    ),
                                    trailing: Text(
                                      'Qtd: ${widget.data[index].quantInvent}',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                /*  */
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text("Confirmar"),
          onPressed: () {
            ref
                .read(addressInventoryProvider.notifier)
                .postInventory(loteController.text, vencLote);
          },
          icon: const Icon(Icons.check),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }

  void getProduct(String product) {
    bool isDun = false;
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

          if (element.codigoBarras.toUpperCase() == (product.toUpperCase())) {
            return true;
          }
          if (element.codigoBarras2.toUpperCase() == (product.toUpperCase())) {
            isDun = true;
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
        double quantity = isDun ? selectedProduct.fator : 1;

        //caso o fator seja zero, coloca padrao 1
        if (quantity == 0) {
          quantity = 1;
        }

        if (selectedProduct.fator > 0 && isDun) {
          selectedProduct.isDun = true;
          ref
              .read(addressInventoryProvider.notifier)
              .setIsDun(selectedProduct, true);
        } else {
          selectedProduct.isDun = false;
          ref
              .read(addressInventoryProvider.notifier)
              .setIsDun(selectedProduct, false);
        }
        if (selectedProduct.lote.startsWith('L')) {
          setState(() {
            isLote = true;
            prodInv = selectedProduct;
          });
          loteFocus.requestFocus();
        } else {
          setState(() {
            isLote = false;
            prodInv = selectedProduct;
            loteController.clear();
            vencLote = "";
            isValidDateLote = false;
          });
        }

        ref
            .read(addressInventoryProvider.notifier)
            .addProduct(selectedProduct, quantity);
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
