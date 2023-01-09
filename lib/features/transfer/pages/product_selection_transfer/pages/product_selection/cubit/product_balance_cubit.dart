import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/data/model/product_balance_model.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/data/repositories/product_balance_repository.dart';

part 'product_balance_state.dart';

class ProductBalanceCubit extends Cubit<ProductBalanceCubitState> {
  final ProductBalanceRepository repository;
  final String barcode;

  ProductBalanceCubit(this.repository, this.barcode)
      : super(ProductBalanceCubitInitial()) {
    fetchProductBalance(barcode);
  }

  Future<void> fetchProductBalance(String barcode) async {
    emit(ProductBalanceCubitLoading());

    final result = await repository.fetchProductBalance(barcode);

    if (result.isRight()) {
      result.fold((l) => null, (r) {
        emit(
          ProductBalanceCubitLoaded(productBalance: r),
        );
      });
    } else {
      result.fold((l) => emit(ProductBalanceCubitError(l)), (r) => null);
    }
  }
}
