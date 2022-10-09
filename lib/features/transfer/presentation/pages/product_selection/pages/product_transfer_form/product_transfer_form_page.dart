import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/data/model/product_balance_model.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/data/repositories/product_transfer_repository.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_transfer_form/cubit/product_transfer_cubit.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_transfer_form/widgets/product_transfer_form.dart';

class ProductTransferFormPage extends StatelessWidget {
  const ProductTransferFormPage({super.key, required this.productDetail});
  final ProductBalanceModel productDetail;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ProductTransferCubit(ProductTransferRepository()),
        child: ProductSelectedDetail(
          productDetail: productDetail,
        ));
  }
}
