import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/picking/data/model/picking_model.dart';
import 'package:nexus_estoque/features/picking/data/repositories/picking_repository.dart';

part 'picking_save_state.dart';

class PickingSaveCubit extends Cubit<PickingSaveState> {
  PickingSaveCubit(this.pickingRepository) : super(PickingSaveInitial());
  final PickingRepository pickingRepository;

  void postPicking(PickingModel picking) async {
    emit(PickingSaveLoading());
    final result = await pickingRepository.postPicking(picking);
    if (result.isRight()) {
      result.fold((l) => null, (r) {
        emit(
          PickingSaveLoaded(),
        );
      });
    } else {
      result.fold((l) => emit(PickingSaveError(failure: l)), (r) => null);
    }
  }
}
