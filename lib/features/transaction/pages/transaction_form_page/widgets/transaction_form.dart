import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/features/searches/addresses/page/address_search_page.dart';
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: TextFormField(
                      validator: isNotEmpty,
                      decoration: InputDecoration(
                        label: const Text("Armazem"),
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.qr_code),
                        suffixIcon: IconButton(
                          onPressed: () {
                            WarehouseSearchModal.show(context);
                          },
                          icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
                        ),
                        //icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
                      ),
                    ),
                  ),
                  if (widget.product.lote == 'L')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextFormField(
                        enabled: true,
                        validator: isNotEmpty,
                        decoration: InputDecoration(
                          label: const Text("Lote"),
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.qr_code),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon:
                                const FaIcon(FontAwesomeIcons.magnifyingGlass),
                          ),
                          //icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
                        ),
                      ),
                    ),
                  if (widget.product.localizacao == 'S')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextFormField(
                        enabled: true,
                        validator: isNotEmpty,
                        decoration: InputDecoration(
                          label: const Text("Endereço"),
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.qr_code),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon:
                                const FaIcon(FontAwesomeIcons.magnifyingGlass),
                          ),
                        ),
                      ),
                    ),
                  InputSearchWidget(
                    label: "teste",
                    validator: isNotEmpty,
                    onPressed: () {
                      //warehouseSearch();
                      AddressSearchModal.show(context);
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //context.read<ProductBalanceCubit>().reset();

                      final isValid = formKey.currentState!.validate();
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
