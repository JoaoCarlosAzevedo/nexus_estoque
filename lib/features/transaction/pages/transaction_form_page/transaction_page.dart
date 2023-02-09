import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/features/product_balance/pages/product_selection/cubit/product_balance_cubit.dart';
import 'package:nexus_estoque/core/features/product_balance/pages/product_selection/product_selection_page.dart';
import 'package:nexus_estoque/features/transaction/data/repositories/transaction_repository.dart';
import 'package:nexus_estoque/features/transaction/pages/transaction_form_page/cubit/transaction_cubit.dart';
import 'package:nexus_estoque/features/transaction/pages/transaction_form_page/widgets/transaction_form.dart';

class ProductTransactionPage extends ConsumerWidget {
  const ProductTransactionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProductSelectionPage(
      title: "Movimentos",
      icon: FontAwesomeIcons.cartFlatbed,
      builder: (BuildContext context, ProductBalanceModel productBalance) {
        return BlocProvider(
          create: (context) =>
              TransactionCubit(ref.read(transactionRepository)),
          child: BlocListener<TransactionCubit, TransactionState>(
            listener: (context, state) {
              if (state is TransactionError) {
                showError(context, state.failure.error);
              }

              if (state is TransactionLoaded) {
                context.read<ProductBalanceCubit>().reset();
              }
            },
            child: BlocBuilder<TransactionCubit, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return TransactionFormPage(
                  product: productBalance,
                );
              },
            ),
          ),
        );
      },
    );
  }

  void showError(context, String error) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            desc: error,
            btnOkOnPress: () {},
            btnOkColor: Theme.of(context).primaryColor)
        .show();
  }
}
