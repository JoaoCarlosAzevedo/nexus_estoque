part of 'product_transfer_cubit_cubit.dart';

abstract class ProductTransferCubitState extends Equatable {
  const ProductTransferCubitState();

  @override
  List<Object> get props => [];
}

class ProductTransferCubitInitial extends ProductTransferCubitState {}

class ProductTransferCubitLoading extends ProductTransferCubitState {}

class ProductTransferCubitLoaded extends ProductTransferCubitState {}

class ProductTransferCubitError extends ProductTransferCubitState {}
