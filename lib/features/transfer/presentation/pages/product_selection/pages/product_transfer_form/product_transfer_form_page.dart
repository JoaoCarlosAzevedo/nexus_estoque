import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/data/model/product_balance_model.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/data/repositories/product_transfer_repository.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_selection/product_transfer_page.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_transfer_form/cubit/product_transfer_cubit.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_transfer_form/widgets/product_transfer_form.dart';

class ProductTransferFormPage extends StatelessWidget {
  const ProductTransferFormPage({super.key, required this.productDetail});
  final ProductBalanceModel productDetail;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductTransferCubit(ProductTransferRepository()),
      child: BlocListener<ProductTransferCubit, ProductTransferState>(
        listener: (context, state) {
          if (state is ProductTransferError) {
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    //title: 'Alerta',
                    desc: state.error.error,
                    //btnCancelOnPress: () {},
                    btnOkOnPress: () {},
                    btnOkColor: Theme.of(context).primaryColor)
                .show();
          }

          if (state is ProductTransferLoaded) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<ProductTransferCubit, ProductTransferState>(
          builder: (context, state) {
            if (state is ProductTransferLoading) {
              return const Loading();
            }

            return ProductSelectedDetail(
              productDetail: productDetail,
            );
          },
        ),
      ),
    );
  }
}
