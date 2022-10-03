import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/data/model/product_balance_model.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/data/repositories/product_balance_repository.dart';

part 'product_balance_cubit_state.dart';

class ProductBalanceCubitCubit extends Cubit<ProductBalanceCubitState> {
  final ProductBalanceRepository repository;
  final String barcode;

  ProductBalanceCubitCubit(this.repository, this.barcode)
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
