// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'address_balance_cubit.dart';

abstract class AddressBalanceState extends Equatable {
  const AddressBalanceState();

  @override
  List<Object> get props => [];
}

class AddressBalanceInitial extends AddressBalanceState {}

class AddressBalanceLoading extends AddressBalanceState {}

class AddressBalanceLoaded extends AddressBalanceState {
  final List<AddressBalanceModel> addressBalances;
  const AddressBalanceLoaded({
    required this.addressBalances,
  });
}

class AddressBalanceError extends AddressBalanceState {
  final Failure error;
  const AddressBalanceError({
    required this.error,
  });
}
