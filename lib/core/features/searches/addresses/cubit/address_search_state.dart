import 'package:equatable/equatable.dart';

import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/features/searches/addresses/data/model/address_model.dart';

abstract class AddressSearchState extends Equatable {}

class AddressSearchInitial extends AddressSearchState {
  @override
  List<Object?> get props => [];
}

class AddressSearchLoading extends AddressSearchState {
  @override
  List<Object?> get props => [];
}

class AddressSearchLoaded extends AddressSearchState {
  final List<AddressModel> addressess;

  AddressSearchLoaded({
    required this.addressess,
  });

  @override
  List<Object?> get props => [addressess];
}

class AddressSearchError extends AddressSearchState {
  final Failure error;

  AddressSearchError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
