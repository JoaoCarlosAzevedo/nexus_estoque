part of 'product_balance_cubit.dart';

abstract class ProductBalanceCubitState extends Equatable {
  const ProductBalanceCubitState();

  @override
  List<Object> get props => [];
}

class ProductBalanceCubitInitial extends ProductBalanceCubitState {}

class ProductBalanceCubitLoading extends ProductBalanceCubitState {}

class ProductBalanceCubitLoaded extends ProductBalanceCubitState {
  final ProductBalanceModel productBalance;

  const ProductBalanceCubitLoaded({
    required this.productBalance,
  });
}

class ProductBalanceCubitError extends ProductBalanceCubitState {
  final Failure error;
  const ProductBalanceCubitError(this.error);
}
