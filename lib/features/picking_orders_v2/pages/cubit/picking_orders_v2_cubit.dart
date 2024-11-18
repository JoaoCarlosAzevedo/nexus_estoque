import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';

import '../../../picking_load_v2/data/model/pickingv2_model.dart';

import '../../data/repositories/picking_orders_v2_repository.dart';

part 'picking_orders_v2_state.dart';

class PickingOrdersV2Cubit extends Cubit<PickingOrdersV2State> {
  final PickingOrdersV2Repository repository;
  PickingOrdersV2Cubit(this.repository) : super(PickingOrdersV2Initial()) {
    fetchPickingOrdersv2();
  }

  void setRedirect(String load) {
    if (state is PickingOrdersV2Loaded) {
      emit(PickingOrdersV2Loading());
      emit(PickingOrdersV2Redirect(load: load));
    }
  }

  void fetchPickingOrdersv2() async {
    emit(PickingOrdersV2Loading());

    final data = await repository.fetchOrdersV2();

    data.fold((l) => emit(PickingOrdersV2Error(error: l)),
        (r) => emit(PickingOrdersV2Loaded(loads: r, load: '')));
  }
}
