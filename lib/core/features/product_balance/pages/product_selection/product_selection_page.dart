import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/features/product_balance/data/repositories/product_balance_repository.dart';
import 'package:nexus_estoque/core/features/product_balance/pages/product_selection/cubit/product_balance_cubit.dart';
import 'package:nexus_estoque/core/features/product_balance/pages/product_selection/widget/product_selection_form.dart';

typedef ProductBalanceWidgetBuilder = Widget Function(
    BuildContext context, ProductBalanceModel product);

class ProductSelectionPage extends ConsumerWidget {
  const ProductSelectionPage(
      {super.key,
      required this.title,
      required this.icon,
      required this.builder,
      this.param});
  final String title;
  final FaIconData icon;
  final dynamic param;

  final ProductBalanceWidgetBuilder builder;

  void hideKeyboard() {
    Future.delayed(
      const Duration(milliseconds: 500),
      () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(productBalanceRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
          //backgroundColor: AppColors.background,
          ),
      body: BlocProvider(
        create: (context) => ProductBalanceCubit(repository),
        child: BlocListener<ProductBalanceCubit, ProductBalanceCubitState>(
          listener: (context, state) {
            if (state is ProductBalanceCubitError) {
              showError(context, state.error.error);
            }
          },
          child: BlocBuilder<ProductBalanceCubit, ProductBalanceCubitState>(
            builder: (context, state) {
              if (state is ProductBalanceCubitLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is ProductBalanceCubitLoaded) {
                return PopScope(
                    onPopInvokedWithResult: (didPop, _) async {
                      if (didPop) return;
                      context.read<ProductBalanceCubit>().reset();
                      context.pop();
                    },
                    child: builder(context, state.productBalance));
              }
              hideKeyboard();
              return ProductSelectioForm(
                title: title,
                icon: icon,
                param: param,
              );
            },
          ),
        ),
      ),
    );
  }

  // ignore: strict_top_level_inference
  void showError(BuildContext context, String error) {
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
