import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/data/repositories/product_transfer_repository.dart';

part 'product_transfer_state.dart';

class ProductTransferCubit extends Cubit<ProductTransferState> {
  final ProductTransferRepository repository;

  ProductTransferCubit(
    this.repository,
  ) : super(ProductTransferInitial());

  void postTransfer(String json) async {
    emit(ProductTransferLoading());

    final result = await repository.postTransfer(json);

    if (result.isRight()) {
      result.fold((l) => null, (r) {
        emit(
          ProductTransferLoaded(r),
        );
      });
    } else {
      result.fold((l) => emit(ProductTransferError(l)), (r) => null);
    }
  }
}
