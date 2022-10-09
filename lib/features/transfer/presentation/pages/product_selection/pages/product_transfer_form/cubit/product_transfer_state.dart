part of 'product_transfer_cubit.dart';

abstract class ProductTransferState extends Equatable {
  const ProductTransferState();

  @override
  List<Object> get props => [];
}

class ProductTransferInitial extends ProductTransferState {}

class ProductTransferLoading extends ProductTransferState {}

class ProductTransferLoaded extends ProductTransferState {
  final String success;

  const ProductTransferLoaded(this.success);
}

class ProductTransferError extends ProductTransferState {
  final Failure error;
  const ProductTransferError(this.error);
}
