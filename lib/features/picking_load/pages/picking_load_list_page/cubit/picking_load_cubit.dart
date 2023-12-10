import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../../picking_route/data/model/shipping_model.dart';
import '../../../../picking_route/data/repositories/picking_route_repository.dart';

part 'picking_load_state.dart';

class PickingLoadCubit extends Cubit<PickingLoadState> {
  final PickingRouteRepository repository;
  PickingLoadCubit(this.repository) : super(PickingLoadInitial()) {
    fetchPickingLoads();
  }

  void fetchPickingLoads() async {
    emit(PickingLoadLoading());

    final data = await repository.fetchPickingLoadList();

    data.fold(
        (l) => emit(PickingLoadError(error: l)),
        (r) => emit(PickingLoadLoaded(
              loads: r,
            )));
  }
}
