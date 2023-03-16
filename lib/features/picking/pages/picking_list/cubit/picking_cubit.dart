import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/picking/data/model/picking_model.dart';
import 'package:nexus_estoque/features/picking/data/repositories/picking_repository.dart';

part 'picking_state.dart';

class PickingCubitCubit extends Cubit<PickingCubitState> {
  PickingCubitCubit(this.pickingRepositoryl) : super(PickingCubitInitial()) {
    fetchPickingList();
  }
  final PickingRepository pickingRepositoryl;

  void fetchPickingList() async {
    emit(PickingCubitLoading());

    final result = await pickingRepositoryl.fetchPickingList();
    if (result.isRight()) {
      result.fold((l) => null, (r) {
        emit(
          PickingCubiLoaded(r),
        );
      });
    } else {
      result.fold((l) => emit(PickingCubitError(failure: l)), (r) => null);
    }
  }
}
