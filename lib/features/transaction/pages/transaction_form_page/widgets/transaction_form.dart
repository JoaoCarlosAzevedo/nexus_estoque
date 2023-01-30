import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/features/product_balance/pages/product_selection/cubit/product_balance_cubit.dart';
import 'package:nexus_estoque/core/features/searches/addresses/page/address_search_page.dart';
import 'package:nexus_estoque/core/mixins/validation_mixin.dart';
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
                  TextFormField(
                    validator: isNotEmpty,
                    decoration: InputDecoration(
                      label: const Text("Armazem"),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.qr_code),
                      suffixIcon: IconButton(
                        onPressed: () {
                          warehouseSearch();
                        },
                        icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
                      ),
                      //icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  TextFormField(
                    enabled: true,
                    validator: (value) => isNotEmpty(value, "Lote Obrigatório"),
                    decoration: InputDecoration(
                      label: const Text("Lote"),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.qr_code),
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
                      ),
                      //icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  TextFormField(
                    enabled: true,
                    decoration: InputDecoration(
                      label: const Text("Endereço"),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.qr_code),
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
                      ),
                      //icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductBalanceCubit>().reset();

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

  void warehouseSearch() async {
    final result = await showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext context) {
        //return const WarehouseSearchPage();
        //return const WarehouseSearchPage();
        //return const ProductSearchPage();
        return const AddressSearchPage(
          warehouse: '01',
        );
/*         return BatchSearchPage(
            product: ProductArg(product: '45274905', warehouse: '01')); */
      },
    );

    if (result != null) {
      log(result);
    }
  }
}
