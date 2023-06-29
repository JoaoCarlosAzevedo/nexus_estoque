import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/product_balance/data/repositories/product_balance_repository.dart';
import 'package:nexus_estoque/core/features/product_balance/pages/product_selection/cubit/product_balance_cubit.dart';
import 'package:nexus_estoque/features/address/pages/product_address_form_page/address_form_page.dart';
import 'package:nexus_estoque/features/product_balance/pages/product_balance/widgets/product_balance_data_widget.dart';

class ProductBalancePage extends ConsumerStatefulWidget {
  const ProductBalancePage({required this.productCode, super.key});
  final String productCode;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductBalancePageState();
}

class _ProductBalancePageState extends ConsumerState<ProductBalancePage> {
  @override
  Widget build(BuildContext context) {
    final repository = ref.read(productBalanceRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta Produto"),
      ),
      body: BlocProvider(
        create: (context) =>
            ProductBalanceCubit(repository, code: widget.productCode),
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
                return ProductBalanceDataWidget(
                  productBalance: state.productBalance,
                );
              }

              return const Center(
                child: Text("Erro ao carregar"),
              );
            },
          ),
        ),
      ),
    );
  }
}
