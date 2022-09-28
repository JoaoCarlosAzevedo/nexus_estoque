part of 'product_address_form_cubit.dart';

abstract class ProductAddressFormState extends Equatable {
  const ProductAddressFormState();

  @override
  List<Object> get props => [];
}

class ProductAddressFormInitial extends ProductAddressFormState {}

class ProductAddressFormLoading extends ProductAddressFormState {}

class ProductAddressFormSuccess extends ProductAddressFormState {}

class ProductAddressFormError extends ProductAddressFormState {}

class ProductAddressFormValidation extends ProductAddressFormState {}
