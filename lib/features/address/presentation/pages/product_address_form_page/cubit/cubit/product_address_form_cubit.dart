import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/address/data/repositories/product_address_repository.dart';

part 'product_address_form_state.dart';

class ProductAddressFormCubit extends Cubit<ProductAddressFormState> {
  final ProductAddressRepository productAddressRepository;

  ProductAddressFormCubit(this.productAddressRepository)
      : super(ProductAddressFormInitial());

  void postProductAddress(
      String produto, String codeseq, String endereco, double quantity) async {
    emit(ProductAddressFormLoading());

    final result = await productAddressRepository.addressProduct(
        produto, codeseq, endereco, quantity);

    if (result.isRight()) {
      result.fold((l) => null, (r) {
        emit(
          ProductAddressFormSuccess(),
        );
      });
    } else {
      result.fold((l) {
        if (l.errorType == ErrorType.validation) {
          emit(ProductAddressFormValidation());
        }

        emit(ProductAddressFormError());
      }, (r) => null);
    }
  }
}
