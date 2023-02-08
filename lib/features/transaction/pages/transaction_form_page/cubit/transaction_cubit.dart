import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/transaction/data/model/transaction_model.dart';
import 'package:nexus_estoque/features/transaction/data/repositories/transaction_repository.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit(this.repository) : super(TransactionInitial());
  final TransactionRepository repository;

  Future<void> postTransaction(TransactionModel transaction, String tm) async {
    emit(TransactionLoading());

    final result = await repository.postTransaction(transaction, tm);

    if (result.isRight()) {
      result.fold((l) => null, (r) {
        emit(TransactionLoaded());
      });
    } else {
      result.fold((l) => emit(TransactionError(l)), (r) => null);
    }
  }
}
