import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/features/searches/batches/pages/batches_search_page.dart';
import 'package:nexus_estoque/core/mixins/validation_mixin.dart';
import 'package:nexus_estoque/core/features/searches/warehouses/data/model/warehouse_search_model.dart';
import 'package:nexus_estoque/core/features/searches/warehouses/pages/warehouse_search_page.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/data/model/product_balance_model.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key, required this.product});
  final ProductBalanceModel product;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> with ValidationMixi {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            const Text("Campos Input"),
            SizedBox(
              height: height * 0.03,
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
              height: height * 0.03,
            ),
            TextFormField(
              enabled: false,
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
              height: height * 0.03,
            ),
            TextFormField(
              enabled: false,
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
    );
  }

  void warehouseSearch() async {
    final result = await showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext context) {
        //return const WarehouseSearchPage();
        return const BatchSearchPage();
      },
    );

    if (result != null) {
      print(result);
    }
  }
}
