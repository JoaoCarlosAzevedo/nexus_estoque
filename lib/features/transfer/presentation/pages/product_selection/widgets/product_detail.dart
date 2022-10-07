import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/data/model/product_balance_model.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/widgets/address_balance_search.dart';
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
            Container(
              //height: height / 5,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 16.0, left: 16.0, right: 16.00),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productDetail.descricao,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    //const Divider(),
                    Text(
                      "Código: ${widget.productDetail.codigo}",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    //const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.productDetail.codigoBarras,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10, bottom: 10),
                          child: Text(
                            "${widget.productDetail.stock} ${widget.productDetail.uM}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                  TextField(
                    enabled: true,
                    autofocus: false,
                    controller: origWarehouseController,
                    onSubmitted: (e) {},
                    decoration: InputDecoration(
                      label: const Text("Local"),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.qr_code),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          final Armazem result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WarehouseBalanceSearch(
                                      warehouseBalances:
                                          widget.productDetail.armazem,
                                    )),
                          );

                          origWarehouse = result;
                          origWarehouseController.text = result.armz;
                          destWarehouseController.text = result.armz;
                        },
                        icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
                      ),
                      //icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
                    ),
                  ),
                  const Divider(),
                  TextField(
                    enabled: true,
                    autofocus: false,
                    controller: origAddressController,
                    onSubmitted: (e) {},
                    decoration: InputDecoration(
                      label: const Text("Endereços"),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.qr_code),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddressBalance(
                                      addressBalance: origWarehouse.enderecos,
                                    )),
                          );
                          origAddressController.text = result;
                          destAddressController.text = result;
                        },
                        icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
                      ),
                      //icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
                    ),
                  ),
                  const Divider(),
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
                  TextField(
                    enabled: false,
                    autofocus: false,
                    controller: destWarehouseController,
                    onSubmitted: (e) {},
                    decoration: InputDecoration(
                      label: const Text("Armazem"),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.qr_code),
                      suffixIcon: IconButton(
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
                        icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
                      ),
                      //icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
                    ),
                  ),
                  const Divider(),
                  TextField(
                    enabled: true,
                    autofocus: false,
                    controller: destAddressController,
                    onSubmitted: (e) {},
                    decoration: InputDecoration(
                      label: const Text("Endereço"),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.qr_code),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddressBalance(
                                      addressBalance: widget
                                          .productDetail.armazem[1].enderecos,
                                    )),
                          );
                          destAddressController.text = result;
                        },
                        icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
                      ),
                      //icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          _setValue(-1);
                        },
                        iconSize: 30,
                        icon: const Icon(
                          Icons.remove,
                          color: AppColors.primaryRed,
                        ),
                      ), // decrease qty button
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          onSubmitted: (e) {},
                          onChanged: (e) {
                            var intParsed = int.tryParse(e);

                            if (intParsed != null) {
                              if (int.parse(e) <= 0) {
                                quantityController.text = '0';
                                quantityController.selection =
                                    TextSelection.collapsed(
                                        offset: quantityController.text.length);
                              }
                            }
                          },
                        ),
                      ),
                      IconButton(
                        iconSize: 30,
                        onPressed: () {
                          _setValue(1);
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
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

  void _setValue(int number) {
    int isPositive = int.parse(quantityController.text) + number;

    if (isPositive >= 0) {
      quantityController.text =
          (int.parse(quantityController.text) + number).toString();
      quantityController.selection =
          TextSelection.collapsed(offset: quantityController.text.length);
    }
  }
}
