import 'package:bloc/bloc.dart';

import 'package:nexus_estoque/core/pages/searches/address/cubit/address_search_state.dart';
import 'package:nexus_estoque/core/pages/searches/address/data/repositories/address_search_repository.dart';

class AddressSearchCubit extends Cubit<AddressSearchState> {
  final AddressSearchRepository repository;
  final String warehouse;

  AddressSearchCubit(
    this.repository,
    this.warehouse,
  ) : super(AddressSearchInitial()) {
    fetchAddress(warehouse);
  }
  void cleanCache() {
    repository.cleanCache();
    fetchAddress(warehouse);
  }

  Future<void> fetchAddress(String warehouse) async {
    emit(AddressSearchLoading());

    final result = await repository.fetchAddress(warehouse);

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
