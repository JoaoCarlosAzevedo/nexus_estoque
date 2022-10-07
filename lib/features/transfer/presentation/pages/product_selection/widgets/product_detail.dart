import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nexus_estoque/core/pages/searches/products/pages/products_search_page.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/data/model/product_balance_model.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/widgets/address_balance_search.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/widgets/input_quantity.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/widgets/input_text.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/widgets/produc_transfer_card.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/widgets/warehouse_balance_search.dart';

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

  late Armazem origWarehouse;

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
                    controller: origWarehouseController,
                    enabled: true,
                    onPressed: () {
                      warehouseSearch();
                    },
                    onSubmitted: () {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputText(
                    label: "Endereços",
                    controller: origAddressController,
                    enabled: true,
                    onPressed: () {
                      addressSearch();
                    },
                    onSubmitted: () {},
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
                    controller: destAddressController,
                    enabled: true,
                    onPressed: () {
                      addressSearch();
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
                      creatJson();
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
    /*   final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WarehouseBalanceSearch(
                warehouseBalances: widget.productDetail.armazem,
              )),
    );

    if (result != null) {
      origWarehouse = result as Armazem;
      origWarehouseController.text = result.armz;
      destWarehouseController.text = result.armz;
    } */
    final result = await showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return ProductSearchPage();
      },
    );
    print(result);
  }

  void addressSearch() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddressBalance(
                addressBalance: origWarehouse.enderecos,
              )),
    );

    if (result != null) {
      origAddressController.text = result;
      destAddressController.text = result;
    }
  }

  void creatJson() {
    final jsonOrig = {
      'produto': widget.productDetail.codigo,
      'local': origAddressController.text,
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
      'quantidade': quantityController.text,
      'origem': jsonOrig,
      'destino': jsonDest
    };

    final jsonString = jsonEncode(json);
    print(jsonString);
  }
}
