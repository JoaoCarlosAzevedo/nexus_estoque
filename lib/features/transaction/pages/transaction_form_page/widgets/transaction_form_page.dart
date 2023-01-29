import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/features/product_balance/pages/product_selection/cubit/product_balance_cubit.dart';
import 'package:nexus_estoque/core/features/searches/addresses/page/address_search_page.dart';
import 'package:nexus_estoque/core/mixins/validation_mixin.dart';

class TransactionFormPage extends StatefulWidget {
  const TransactionFormPage({super.key, required this.product});
  final ProductBalanceModel product;

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage>
    with ValidationMixi {
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
