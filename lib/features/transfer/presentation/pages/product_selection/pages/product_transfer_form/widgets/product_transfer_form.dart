import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_estoque/core/pages/searches/address/page/address_search_page.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/data/model/product_balance_model.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_transfer_form/cubit/product_transfer_cubit.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_transfer_form/widgets/address_balance_search.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_transfer_form/widgets/input_quantity.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_transfer_form/widgets/input_text.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_transfer_form/widgets/produc_transfer_card.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_transfer_form/widgets/warehouse_balance_search.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProductTransferCard(
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
                    label: "Local",
                    focus: destWarehouseFocus,
                    controller: destWarehouseController,
                    enabled: false,
                    onPressed: () async {
                      final Armazem result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WarehouseBalanceSearch(
                                  warehouseBalances:
                                      widget.productDetail.armazem,
                                )),
                      );

                      origWarehouseController.text = result.armz;
                    },
                    onSubmitted: () {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
      destAddressController.text = tapedAddress.codLocalizacao;
    }
  }

  void allAddressSearch() async {
    final result = await showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return const AddressSearchPage();
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
