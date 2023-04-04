import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/outflow_doc_check/data/model/outflow_doc_model.dart';
import 'package:nexus_estoque/features/outflow_doc_check/data/repositories/outflow_doc_repository.dart';

part 'outflow_doc_state.dart';

class OutFlowDocCubit extends Cubit<OutFlowDocState> {
  final OutflowDocRepository repository;
  OutFlowDocCubit(this.repository) : super(OutFlowDocInitial()) {
    fetchOutFlowDoc();
  }

  void fetchOutFlowDoc() async {
    emit(OutFlowDocLoading());

    final result = await repository.fetchOutflowDoc();

    if (result.isRight()) {
      result.fold((l) => null, (r) {
        emit(
          OutFlowDocLoaded(r),
        );
      });
    } else {
      result.fold((l) => emit(OutFlowDocError(l)), (r) => null);
    }
  }
}
