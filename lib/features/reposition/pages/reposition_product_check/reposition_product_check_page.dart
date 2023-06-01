import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/features/product_balance/pages/product_selection/cubit/product_balance_cubit.dart';
import 'package:nexus_estoque/core/features/product_balance/pages/product_selection/product_selection_page.dart';
import 'package:nexus_estoque/features/address/pages/product_address_form_page/address_form_page.dart';
import 'package:nexus_estoque/features/reposition/data/model/reposition_transfer_moderl.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/data/repositories/product_transfer_repository.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/cubit/product_transfer_cubit.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/transfer_form_page.dart';

class RepositionProductCheck extends ConsumerStatefulWidget {
  const RepositionProductCheck({required this.productReposition, super.key});

  final RepositionTrasnferModel productReposition;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RepositionProductCheckState();
}

class _RepositionProductCheckState
    extends ConsumerState<RepositionProductCheck> {
  @override
  Widget build(BuildContext context) {
    return ProductSelectionPage(
      title: "Reposição",
      icon: FontAwesomeIcons.boxesStacked,
      param: widget.productReposition,
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
                Navigator.pop(context);
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
                  reposition: widget.productReposition,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
