import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'product_address_form_state.dart';

class ProductAddressFormCubit extends Cubit<ProductAddressFormState> {
  ProductAddressFormCubit() : super(ProductAddressFormInitial());
}
