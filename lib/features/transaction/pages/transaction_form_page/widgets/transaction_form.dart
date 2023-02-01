import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/features/searches/addresses/page/address_search_page.dart';
import 'package:nexus_estoque/core/features/searches/batches/pages/batches_search_page.dart';
import 'package:nexus_estoque/core/features/searches/warehouses/pages/warehouse_search_page.dart';
import 'package:nexus_estoque/core/mixins/validation_mixin.dart';
import 'package:nexus_estoque/core/widgets/form_input_search_widget.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form/widgets/produc_transfer_card.dart';

class TransactionFormPage extends StatefulWidget {
  const TransactionFormPage({super.key, required this.product});
  final ProductBalanceModel product;

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

enum Tm { entrada, saida }

class _TransactionFormPageState extends State<TransactionFormPage>
    with ValidationMixi {
  final formKey = GlobalKey<FormState>();
  Tm? tmSelected = Tm.entrada;
  final TextEditingController warehouseController = TextEditingController();
  final TextEditingController batchController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    warehouseController.text = widget.product.localPadrao;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            ProductHeaderCard(
              productDetail: widget.product,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Radio<Tm>(
                            value: Tm.entrada,
                            groupValue: tmSelected,
                            onChanged: (Tm? value) {
                              setState(() {
                                tmSelected = value;
                              });
                            },
                          ),
                          const Text("Entrada")
                        ],
                      ),
                      Row(
                        children: [
                          Radio<Tm>(
                            value: Tm.saida,
                            groupValue: tmSelected,
                            onChanged: (Tm? value) {
                              setState(() {
                                tmSelected = value;
                              });
                            },
                          ),
                          const Text("Saida")
                        ],
                      ),
                    ],
                  ),
                  InputSearchWidget(
                    label: "Armazem",
                    controller: warehouseController,
                    validator: isNotEmpty,
                    onPressed: () async {
                      final value = await WarehouseSearchModal.show(context);
                      warehouseController.text = value;
                    },
                  ),
                  if (widget.product.lote == 'L')
                    InputSearchWidget(
                      label: "Lote",
                      controller: batchController,
                      validator: isNotEmpty,
                      onPressed: () async {
                        final value = await BatchSearchModal.show(context,
                            widget.product.codigo, warehouseController.text);
                        batchController.text = value;
                      },
                    ),
                  if (widget.product.localizacao == 'S')
                    InputSearchWidget(
                      label: "Endereço",
                      controller: addressController,
                      validator: isNotEmpty,
                      onPressed: () async {
                        final value = await AddressSearchModal.show(
                            context, warehouseController.text);
                        addressController.text = value;
                      },
                    ),
                  ElevatedButton(
                    onPressed: () {
                      //context.read<ProductBalanceCubit>().reset();

                      final isValid = formKey.currentState!.validate();
                      if (isValid) {
                        log(batchController.text);
                        log(warehouseController.text);
                        log(addressController.text);
                        log(tmSelected.toString());
                      }
                      log(isValid.toString());
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
}
