import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/data/model/product_balance_model.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/data/repositories/product_balance_repository.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_selection/cubit/product_balance_cubit.dart';

class ProductBalancePage extends ConsumerWidget {
  const ProductBalancePage({super.key, required this.barcode});
  final String barcode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) =>
            ProductBalanceCubit(ref.read(productBalanceRepository), barcode),
        child: BlocBuilder<ProductBalanceCubit, ProductBalanceCubitState>(
          builder: (context, state) {
            if (state is ProductBalanceCubitLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ProductBalanceCubitError) {
              return Center(
                child: Text(state.error.error),
              );
            }

            if (state is ProductBalanceCubitLoaded) {
              return ProductBalanceView(
                productBalance: state.productBalance,
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class ProductBalanceView extends StatelessWidget {
  const ProductBalanceView({super.key, required this.productBalance});
  final ProductBalanceModel productBalance;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(productBalance.codigo),
        Text(productBalance.descricao),
        Text(productBalance.localPadrao),
        Text(productBalance.tipo),
        Text(productBalance.lote),
        Text(productBalance.armazem.length.toString()),
        Text(productBalance.stock.toString()),
      ],
    );
  }
}
