import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_estoque/core/error/failure.dart';

import '../../../data/model/pickingv2_model.dart';
import '../../../data/repositories/pickingv2_repository.dart';

part 'picking_save_v2_state.dart';

class PickingSavev2Cubit extends Cubit<PickingSavev2State> {
  PickingSavev2Cubit(this.pickingRepository) : super(PickingSavev2Initial());
  final Pickingv2Repository pickingRepository;

  void postPicking(Pickingv2Model picking, List<String> seriais) async {
    emit(PickingSavev2Loading());
    final result = await pickingRepository.postPicking(picking, seriais);
    if (result.isRight()) {
      result.fold((l) => null, (r) {
        emit(
          PickingSavev2Loaded(),
        );
      });
    } else {
      result.fold((l) => emit(PickingSavev2Error(failure: l)), (r) => null);
    }
  }

  void postGroupedPicking(List<Pickingv2Model> picking) async {
    emit(PickingSavev2Loading());
    final result = await pickingRepository.postGroupedPicking(picking);
    if (result.isRight()) {
      result.fold((l) => null, (r) {
        emit(
          PickingSavev2Loaded(),
        );
      });
    } else {
      result.fold((l) => emit(PickingSavev2Error(failure: l)), (r) => null);
    }
  }
}
