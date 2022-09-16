import 'package:bloc/bloc.dart';
import 'package:nexus_estoque/features/address/data/repositories/product_address_repository.dart';
import 'package:nexus_estoque/features/address/presentation/cubit/product_address_state.dart';

class ProductAddressCubit extends Cubit<ProductAddressState> {
  final ProductAddressRepository productAddressRepository;

  ProductAddressCubit(this.productAddressRepository)
      : super(ProductAddresInitial());

  void fetchProductAddress() async {
    emit(ProductAddressLoading());

    final result = await productAddressRepository.fetchProductAddress();

    emit(ProductAddresInitial());

    if (result.isRight()) {
      result.fold((l) => null, (r) {
        emit(
          ProductAddressLoaded(productAddresList: r),
        );
      });
    } else {
      result.fold((l) => emit(ProductAddressError(failure: l)), (r) => null);
    }
  }
}
