import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/data/repositories/product_balance_repository.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_selection/cubit/product_balance_cubit.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_transfer_form/product_transfer_form_page.dart';

class ProductSelectionForm extends ConsumerStatefulWidget {
  final String barcode;
  const ProductSelectionForm({super.key, required this.barcode});

  @override
  ConsumerState<ProductSelectionForm> createState() =>
      _ProductSelectionFormState();
}

class _ProductSelectionFormState extends ConsumerState<ProductSelectionForm> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBalanceCubit(
          ref.read(productBalanceRepository), widget.barcode),
      child: BlocBuilder<ProductBalanceCubit, ProductBalanceCubitState>(
        builder: (context, state) {
          if (state is ProductBalanceCubitLoading) {
            return const Loading();
          }

          if (state is ProductBalanceCubitError) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Text(state.error.error),
              ),
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
