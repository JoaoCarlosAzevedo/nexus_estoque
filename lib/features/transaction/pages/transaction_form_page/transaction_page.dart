import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/features/product_balance/pages/product_selection/product_selection_page.dart';
import 'package:nexus_estoque/features/transaction/pages/transaction_form_page/widgets/transaction_form_page.dart';

class ProductTransactionPage extends ConsumerWidget {
  const ProductTransactionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProductSelectionPage(
      title: "Movimentos",
      icon: FontAwesomeIcons.cartFlatbed,
      onProductLoad: (e) => log(e.codigo),
      builder: (BuildContext context, ProductBalanceModel product) {
        //context.read<ProductBalanceCubit>().reset();
        return TransactionFormPage(
          product: product,
        );
      },
    );
  }
}
