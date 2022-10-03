import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/cubit/product_balance_cubit_cubit.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/data/repositories/product_balance_repository.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/widgets/product_detail.dart';

class ProductSelectionForm extends StatefulWidget {
  final String barcode;
  const ProductSelectionForm({super.key, required this.barcode});

  @override
  State<ProductSelectionForm> createState() => _ProductSelectionFormState();
}

class _ProductSelectionFormState extends State<ProductSelectionForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => ProductBalanceCubitCubit(
            ProductBalanceRepository(), widget.barcode),
        child: BlocBuilder<ProductBalanceCubitCubit, ProductBalanceCubitState>(
          builder: (context, state) {
            print(state);
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
              return Center(
                  child: ProductSelectedDetail(
                productDetail: state.productBalance,
              ));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
