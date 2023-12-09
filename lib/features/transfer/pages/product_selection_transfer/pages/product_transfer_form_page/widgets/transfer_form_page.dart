import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/features/searches/addresses/data/model/address_model.dart';
import 'package:nexus_estoque/core/features/searches/addresses/page/address_search_page.dart';
import 'package:nexus_estoque/core/features/searches/batches/pages/batches_search_page.dart';
import 'package:nexus_estoque/core/features/searches/warehouses/pages/warehouse_search_page.dart';
import 'package:nexus_estoque/core/mixins/validation_mixin.dart';
import 'package:nexus_estoque/core/widgets/form_input_search_widget.dart';
import 'package:nexus_estoque/features/auth/providers/login_state.dart';
import 'package:nexus_estoque/features/reposition/data/model/reposition_transfer_moderl.dart';
import 'package:nexus_estoque/features/transaction/pages/transaction_form_page/widgets/transaction_form.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/cubit/product_transfer_cubit.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/input_quantity.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/produc_transfer_card.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/warehouse_balance_search.dart';

import '../../../../../../auth/providers/login_controller_provider.dart';

class TransferFormPage extends ConsumerStatefulWidget {
  final ProductBalanceModel productDetail;
  final RepositionTrasnferModel? reposition;

  const TransferFormPage(
      {super.key, required this.productDetail, this.reposition});

  @override
  ConsumerState<TransferFormPage> createState() => _TransferFormPageState();
}

class _TransferFormPageState extends ConsumerState<TransferFormPage>
    with ValidationMixi {
  final formKey = GlobalKey<FormState>();

  final TextEditingController origWarehouseController = TextEditingController();
  final TextEditingController destWarehouseController = TextEditingController();
  final TextEditingController origAddressController = TextEditingController();
  final TextEditingController destAddressController = TextEditingController();
  final TextEditingController origBatchController = TextEditingController();
  final TextEditingController destBatchController = TextEditingController();

  final TextEditingController quantityController =
      TextEditingController(text: '1.00');
  bool canChangeWarehouse = false;

  @override
  void initState() {
    if (widget.reposition != null) {
      quantityController.text = widget.reposition!.quantity.toString();
    }
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 500),
      () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
    );
  }

  @override
  void dispose() {
    origWarehouseController.dispose();
    destWarehouseController.dispose();

    origAddressController.dispose();
    destAddressController.dispose();

    origBatchController.dispose();
    destBatchController.dispose();

    quantityController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.read(loginControllerProvider);
    origWarehouseController.text = widget.productDetail.localPadrao;
    destWarehouseController.text = widget.productDetail.localPadrao;
    if (authState is LoginStateSuccess) {
      if (authState.user.displayName.contains("SEPARADOR TRANSFERENCIA")) {
        canChangeWarehouse = true;
      }
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              ProductHeaderCard(
                productDetail: widget.productDetail,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (authState is LoginStateSuccess)
                      Text(authState.user.displayName),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Origem",
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Divider(),
                    InputSearchWidget(
                      label: "Local Origem",
                      controller: origWarehouseController,
                      autoFocus: false,
                      validator: isNotEmpty,
                      onPressed: () async {
                        final value = await WarehouseSearchModal.show(
                            context, widget.productDetail, Tm.saida);
                        origWarehouseController.text = value;
                        destWarehouseController.text = value;
                      },
                      onSubmitted: (e) {},
                    ),
                    if (widget.productDetail.localizacao == 'S')
                      InputSearchWidget(
                        label: "Endereço Origem",
                        controller: origAddressController,
                        validator: isNotEmpty,
                        onPressed: () async {
                          addressSearch(context);
                        },
                        onSubmitted: (e) {},
                      ),
                    if (widget.productDetail.lote == 'L')
                      InputSearchWidget(
                        label: "Lote Origem",
                        controller: origBatchController,
                        validator: isNotEmpty,
                        onPressed: () async {
                          final value = await BatchSearchModal.show(
                              context,
                              widget.productDetail,
                              origWarehouseController.text,
                              Tm.saida);
                          origBatchController.text = value;
                        },
                        onSubmitted: (e) {},
                      ),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Destino",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Divider(),
                    if (canChangeWarehouse)
                      InputSearchWidget(
                        label: "Local Destino",
                        controller: destWarehouseController,
                        validator: isNotEmpty,
                        onPressed: () async {
                          final value = await WarehouseSearchModal.show(
                              context, widget.productDetail, Tm.saida);
                          destWarehouseController.text = value;
                        },
                        onSubmitted: (e) {},
                      ),
                    if (widget.productDetail.localizacao == 'S')
                      InputSearchWidget(
                        label: "Endereço Destino",
                        controller: destAddressController,
                        validator: isNotEmpty,
                        onPressed: () async {
                          allAddressSearch();
                        },
                        onSubmitted: (e) {},
                      ),
                    if (widget.productDetail.lote == 'L')
                      InputSearchWidget(
                        label: "Lote Destino",
                        controller: destBatchController,
                        validator: isNotEmpty,
                        onPressed: () async {
                          final value = await BatchSearchModal.show(
                              context,
                              widget.productDetail,
                              destWarehouseController.text,
                              Tm.entrada);
                          destBatchController.text = value;
                        },
                        onSubmitted: (e) {},
                      ),
                    InputQuantity(
                      controller: quantityController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final isValid = formKey.currentState!.validate();
                        if (isValid) {
                          if (widget.reposition != null) {
                            if (widget.reposition!.origAddress.trim() ==
                                    origAddressController.text.trim() &&
                                widget.reposition!.destAddress.trim() ==
                                    destAddressController.text.trim()) {
                              postTransfer();
                            } else {
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      desc:
                                          "Endereço de Origem ou Destino diferente da reposição",
                                      btnOkOnPress: () {},
                                      btnOkColor:
                                          Theme.of(context).primaryColor)
                                  .show();
                            }
                          } else {
                            postTransfer();
                          }
                        }
                      },
                      child: const SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Center(child: Text("Confirmar")),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void warehouseSearch() async {
    final result = await showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return WarehouseBalanceSearch(
          warehouseBalances: widget.productDetail.armazem,
        );
      },
    );

    if (result != null) {
      final warehouse = result as BalanceWarehouse;
      origWarehouseController.text = warehouse.codigo;
      destWarehouseController.text = warehouse.codigo;
    }
  }

  void addressSearch(context) async {
    final armz = origWarehouseController.text;
    final value =
        await AddressSearchModal.show(context, armz, widget.productDetail);
    if (value is AddressModel) {
      origAddressController.text = value.codigo;
      origBatchController.text = value.lote;
    }
  }

  void allAddressSearch() async {
    destWarehouseController.text = origWarehouseController.text;

    final armz = destWarehouseController.text;

    final result =
        await AddressSearchModal.show(context, armz, widget.productDetail);
    if (result is AddressModel) {
      destAddressController.text = result.codigo;
      destBatchController.text = result.lote;
    }
  }

  void postTransfer() {
    final cubit = BlocProvider.of<ProductTransferCubit>(context);
    final double quantity = double.tryParse(quantityController.text) ?? 0.0;
    //forca o armz de destino
    destWarehouseController.text = origWarehouseController.text;

    final jsonOrig = {
      'produto': widget.productDetail.codigo,
      'local': origWarehouseController.text,
      'lote': origBatchController.text,
      'endereco': origAddressController.text,
    };

    final jsonDest = {
      'produto': widget.productDetail.codigo,
      'local': destWarehouseController.text,
      'lote': destBatchController.text,
      'endereco': destAddressController.text,
    };

    final json = {
      'quantidade': quantity,
      'origem': jsonOrig,
      'destino': jsonDest
    };

    final jsonString = jsonEncode(json);

    cubit.postTransfer(jsonString);
  }
}
