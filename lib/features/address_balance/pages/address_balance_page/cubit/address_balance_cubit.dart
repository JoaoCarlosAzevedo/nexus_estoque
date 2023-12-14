import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/address_balance/data/model/address_balance_model.dart';
import 'package:nexus_estoque/features/address_balance/data/repositories/address_balance_repository.dart';

part 'address_balance_state.dart';

class AddressBalanceCubit extends Cubit<AddressBalanceState> {
  final AddressBalanceRepository repository;

  AddressBalanceCubit({required this.repository})
      : super(AddressBalanceInitial());

  void resetState() {
    emit(AddressBalanceInitial());
  }

  void fetchAddressBalances(String address) async {
    emit(AddressBalanceLoading());

    final response = await repository.fetchAddressBalance(address);

    response.fold((l) => emit(AddressBalanceError(error: l)),
        (r) => emit(AddressBalanceLoaded(addressBalances: r)));
  }
}
