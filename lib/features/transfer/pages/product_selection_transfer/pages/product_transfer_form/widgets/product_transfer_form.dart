import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/features/searches/addresses/page/address_search_page.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form/cubit/product_transfer_cubit.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form/widgets/address_balance_search.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form/widgets/input_quantity.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form/widgets/input_text.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form/widgets/produc_transfer_card.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form/widgets/warehouse_balance_search.dart';

class ProductSelectedDetail extends StatefulWidget {
  final ProductBalanceModel productDetail;

  const ProductSelectedDetail({super.key, required this.productDetail});

  @override
  State<ProductSelectedDetail> createState() => _ProductSelectedDetailState();
}

class _ProductSelectedDetailState extends State<ProductSelectedDetail> {
  final TextEditingController origWarehouseController = TextEditingController();
  final TextEditingController destWarehouseController = TextEditingController();
  final TextEditingController origAddressController = TextEditingController();
  final TextEditingController destAddressController = TextEditingController();
  final TextEditingController quantityController =
      TextEditingController(text: '0');

  final FocusNode origWarehouseFocus = FocusNode();
  final FocusNode destWarehouseFocus = FocusNode();
  final FocusNode origAddressFocus = FocusNode();
  final FocusNode destAddressFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    origAddressFocus.requestFocus();
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
    quantityController.dispose();

    origWarehouseFocus.dispose();
    destWarehouseFocus.dispose();
    origAddressFocus.dispose();
    destAddressFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    origWarehouseController.text = widget.productDetail.localPadrao;
    destWarehouseController.text = widget.productDetail.localPadrao;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
      ),
      body: BlocListener<ProductTransferCubit, ProductTransferState>(
        listener: (context, state) {
          if (state is ProductTransferError) {
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    //title: 'Alerta',
                    desc: state.error.error,
                    //btnCancelOnPress: () {},
                    btnOkOnPress: () {},
                    btnOkColor: Theme.of(context).primaryColor)
                .show();
          }

          if (state is ProductTransferLoaded) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<ProductTransferCubit, ProductTransferState>(
          builder: (context, state) {
            if (state is ProductTransferLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  ProductHeaderCard(
                    productDetail: widget.productDetail,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
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
                        InputText(
                          label: "Local",
                          focus: origWarehouseFocus,
                          controller: origWarehouseController,
                          enabled: true,
                          onPressed: () {
                            warehouseSearch();
                          },
                          onSubmitted: () {
                            origAddressFocus.requestFocus();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputText(
                          label: "Endereços",
                          focus: origAddressFocus,
                          controller: origAddressController,
                          enabled: true,
                          onPressed: () {
                            addressSearch();
                          },
                          onSubmitted: () {
                            destAddressFocus.requestFocus();
                          },
                        ),
                        const SizedBox(
                          height: 20,
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
                        InputText(
                          label: "Endereços",
                          focus: destAddressFocus,
                          controller: destAddressController,
                          enabled: true,
                          onPressed: () {
                            allAddressSearch();
                          },
                          onSubmitted: () {},
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputQuantity(
                          controller: quantityController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            postTransfer();
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
            );
          },
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
      final warehouse = result as Armazem;
      origWarehouseController.text = warehouse.armz;
      destWarehouseController.text = warehouse.armz;
    }
  }

  void addressSearch() async {
    final armz = origWarehouseController.text;
    final addresses = widget.productDetail.armazem
        .firstWhere((element) => element.armz == armz);
    final result = await showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return AddressBalance(
          addressBalance: addresses.enderecos,
        );
      },
    );

    if (result != null) {
      final tapedAddress = result as Enderecos;
      origAddressController.text = tapedAddress.codLocalizacao;
      //destAddressController.text = tapedAddress.codLocalizacao;
    }
  }

  void allAddressSearch() async {
    final result = await showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return AddressSearchPage(
          warehouse: destWarehouseController.text,
        );
      },
    );

    if (result != null) {
      destAddressController.text = result;
    }
  }

  void postTransfer() {
    final cubit = BlocProvider.of<ProductTransferCubit>(context);
    final double quantity = double.tryParse(quantityController.text) ?? 0.0;

    final jsonOrig = {
      'produto': widget.productDetail.codigo,
      'local': origWarehouseController.text,
      'lote': '',
      'endereco': origAddressController.text,
    };

    final jsonDest = {
      'produto': widget.productDetail.codigo,
      'local': destWarehouseController.text,
      'lote': '',
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
