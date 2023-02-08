part of 'transaction_cubit.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionError extends TransactionState {
  final Failure failure;

  const TransactionError(this.failure);
}

class TransactionLoaded extends TransactionState {}
