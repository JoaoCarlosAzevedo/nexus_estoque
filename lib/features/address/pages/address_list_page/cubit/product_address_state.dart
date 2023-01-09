import 'package:equatable/equatable.dart';
import 'package:nexus_estoque/core/error/failure.dart';

import 'package:nexus_estoque/features/address/data/model/product_address_model.dart';

abstract class ProductAddressState extends Equatable {}

class ProductAddresInitial extends ProductAddressState {
  @override
  List<Object?> get props => [];
}

class ProductAddressLoading extends ProductAddressState {
  @override
  List<Object?> get props => [];
}

class ProductAddressLoaded extends ProductAddressState {
  final List<ProductAddressModel> productAddresList;

  ProductAddressLoaded({
    required this.productAddresList,
  });

  @override
  List<Object?> get props => [productAddresList];
}

class ProductAddressError extends ProductAddressState {
  final Failure failure;
  ProductAddressError({
    required this.failure,
  });

  @override
  List<Object?> get props => [failure];
}
