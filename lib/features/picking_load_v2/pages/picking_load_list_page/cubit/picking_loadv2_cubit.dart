import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../data/model/shippingv2_model.dart';
import '../../../data/repositories/pickingv2_repository.dart';

part 'picking_loadv2_state.dart';

class PickingLoadv2Cubit extends Cubit<PickingLoadv2State> {
  final Pickingv2Repository repository;
  PickingLoadv2Cubit(this.repository) : super(PickingLoadv2Initial()) {
    fetchPickingLoads();
  }

  void fetchPickingLoads() async {
    emit(PickingLoadv2Loading());

    final data = await repository.fetchPickingLoadList();

    data.fold(
        (l) => emit(PickingLoadv2Error(error: l)),
        (r) => emit(PickingLoadv2Loaded(
              loads: r,
            )));
  }
}
