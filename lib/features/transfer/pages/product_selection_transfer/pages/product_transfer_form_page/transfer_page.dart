import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/features/product_balance/pages/product_selection/cubit/product_balance_cubit.dart';
import 'package:nexus_estoque/core/features/product_balance/pages/product_selection/product_selection_page.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/data/repositories/product_transfer_repository.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/cubit/product_transfer_cubit.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/transfer_form_page.dart';

class ProductTransferPage extends ConsumerWidget {
  const ProductTransferPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProductSelectionPage(
      title: "Transferências",
      icon: FontAwesomeIcons.cartFlatbed,
      builder: (BuildContext context, ProductBalanceModel productBalance) {
        return BlocProvider(
          create: (context) =>
              ProductTransferCubit(ref.read(productTransferRepository)),
          child: BlocListener<ProductTransferCubit, ProductTransferState>(
            listener: (context, state) {
              if (state is ProductTransferError) {
                showError(context, state.error.error);
              }

              if (state is ProductTransferLoaded) {
                context.read<ProductBalanceCubit>().reset();
              }
            },
            child: BlocBuilder<ProductTransferCubit, ProductTransferState>(
              builder: (context, state) {
                if (state is ProductTransferLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return TransferFormPage(
                  productDetail: productBalance,
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
