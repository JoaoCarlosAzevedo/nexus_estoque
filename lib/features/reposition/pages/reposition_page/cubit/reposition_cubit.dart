import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/reposition/data/model/reposition_model.dart';
import 'package:nexus_estoque/features/reposition/data/repositories/reposition_repository.dart';

part 'reposition_state.dart';

class RepositionCubit extends Cubit<RepositionState> {
  final RepositionRepository repository;
  RepositionCubit({required this.repository}) : super(RepositionInitial()) {
    fetchReposition();
  }

  void fetchReposition() async {
    emit(RepositionLoading());

    final response = await repository.fetchReposition();

    response.fold((l) => emit(RepositionError(error: l)),
        (r) => emit(RepositionLoaded(repositions: r)));
  }
}
