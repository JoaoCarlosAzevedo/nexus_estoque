import 'package:equatable/equatable.dart';
import 'package:nexus_estoque/core/error/failure.dart';

abstract class ProductAddressFormState extends Equatable {}

class ProductAddressFormInitial extends ProductAddressFormState {
  @override
  List<Object> get props => [];
}

class ProductAddressFormCheck extends ProductAddressFormState {
  @override
  List<Object> get props => [];
}

class ProductAddressFormLoading extends ProductAddressFormState {
  @override
  List<Object> get props => [];
}

class ProductAddressFormSuccess extends ProductAddressFormState {
  @override
  List<Object> get props => [];
}

class ProductAddressFormError extends ProductAddressFormState {
  @override
  List<Object> get props => [];
}

class ProductAddressFormValidation extends ProductAddressFormState {
  final Failure failure;

  ProductAddressFormValidation(this.failure);

  @override
  List<Object> get props => [];
}
