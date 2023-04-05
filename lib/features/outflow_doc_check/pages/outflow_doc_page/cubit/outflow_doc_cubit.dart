import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/outflow_doc_check/data/model/outflow_doc_model.dart';
import 'package:nexus_estoque/features/outflow_doc_check/data/repositories/outflow_doc_repository.dart';

part 'outflow_doc_state.dart';

class OutFlowDocCubit extends Cubit<OutFlowDocState> {
  final OutflowDocRepository repository;
  OutFlowDocCubit(this.repository) : super(OutFlowDocInitial());

  void fetchOutFlowDoc(String search) async {
    emit(OutFlowDocLoading());

    final result = await repository.fetchOutflowDoc(search);

    if (result.isRight()) {
      result.fold((l) => null, (r) {
        emit(
          OutFlowDocLoaded(r, null, false),
        );
      });
    } else {
      result.fold((l) => emit(OutFlowDocError(l)), (r) => null);
    }
  }

  void checkProduct(String code) {
    if (state is OutFlowDocLoaded) {
      final aux = state as OutFlowDocLoaded;
      final index = aux.docs.produtos
          .indexWhere((element) => element.codigo.trim() == code.trim());
      emit(OutFlowDocLoading());
      if (index >= 0) {
        aux.docs.produtos[index].checked += 1;
        emit(OutFlowDocLoaded(aux.docs, aux.docs.produtos[index], false));
      } else {
        emit(OutFlowDocLoaded(aux.docs, null, true));
      }
    }
  }
}
