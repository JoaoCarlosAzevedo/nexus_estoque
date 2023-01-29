import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/features/product_balance/data/repositories/product_balance_repository.dart';
import 'package:nexus_estoque/core/features/product_balance/pages/product_selection/cubit/product_balance_cubit.dart';
import 'package:nexus_estoque/core/features/product_balance/pages/product_selection/widget/product_selection_builder.dart';
import 'package:nexus_estoque/core/features/product_balance/pages/product_selection/widget/product_selection_form.dart';

class ProductSelectionPage extends ConsumerWidget {
  const ProductSelectionPage(
      {super.key,
      required this.title,
      required this.icon,
      required this.onProductLoad,
      required this.builder});
  final String title;
  final IconData icon;
  final void Function(ProductBalanceModel) onProductLoad;

  final ProductBalanceWidgetBuilder builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(productBalanceRepositoryProvider);
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => ProductBalanceCubit(repository),
        child: BlocListener<ProductBalanceCubit, ProductBalanceCubitState>(
          listener: (context, state) {
            if (state is ProductBalanceCubitError) {
              showError(context, state.error.error);
            }

            if (state is ProductBalanceCubitLoaded) {
              onProductLoad(state.productBalance);
              //context.read<ProductBalanceCubit>().reset();
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
                return WillPopScope(
                    onWillPop: () async {
                      context.read<ProductBalanceCubit>().reset();
                      return false;
                    },
                    child: builder(context, state.productBalance));
                /*           return Column(
                  children: [
                    Text(state.productBalance.descricao),
                    ElevatedButton(
                        onPressed: () { 
                          context.read<ProductBalanceCubit>().reset();
                        },
                        child: const Text("reset"))
                  ],
                ); */
              }
              return ProductSelectioForm(title: title, icon: icon);
            },
          ),
        ),
      ),
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
