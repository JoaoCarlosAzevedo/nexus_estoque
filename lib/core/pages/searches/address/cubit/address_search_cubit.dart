import 'package:bloc/bloc.dart';
import 'package:nexus_estoque/core/pages/searches/address/cubit/address_search_state.dart';
import 'package:nexus_estoque/core/pages/searches/address/data/repositories/address_search_repository.dart';

class AddressSearchCubit extends Cubit<AddressSearchState> {
  final AddressSearchRepository repository;

  AddressSearchCubit(this.repository) : super(AddressSearchInitial()) {
    fetchAddress();
  }

  Future<void> fetchAddress() async {
    emit(AddressSearchLoading());

    final result = await repository.fetchAddress();

    if (result.isRight()) {
      result.fold((l) => null, (r) {
        emit(
          AddressSearchLoaded(addressess: r),
        );
      });
    } else {
      result.fold((l) => emit(AddressSearchError(error: l)), (r) => null);
    }
  }
}
