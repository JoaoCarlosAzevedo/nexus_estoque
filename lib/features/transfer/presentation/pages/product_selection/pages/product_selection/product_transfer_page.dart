import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/data/repositories/product_balance_repository.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_selection/cubit/product_balance_cubit_cubit.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_transfer_form/product_transfer_form_page.dart';

class ProductSelectionForm extends StatefulWidget {
  final String barcode;
  const ProductSelectionForm({super.key, required this.barcode});

  @override
  State<ProductSelectionForm> createState() => _ProductSelectionFormState();
}

class _ProductSelectionFormState extends State<ProductSelectionForm> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductBalanceCubitCubit(ProductBalanceRepository(), widget.barcode),
      child: BlocBuilder<ProductBalanceCubitCubit, ProductBalanceCubitState>(
        builder: (context, state) {
          if (state is ProductBalanceCubitLoading) {
            return const Loading();
          }

          if (state is ProductBalanceCubitError) {
            return Center(
              child: Text(state.error.error),
            );
          }

          if (state is ProductBalanceCubitLoaded) {
            return Center(
                child: ProductTransferFormPage(
              productDetail: state.productBalance,
            ));
          }
          return Container();
        },
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
