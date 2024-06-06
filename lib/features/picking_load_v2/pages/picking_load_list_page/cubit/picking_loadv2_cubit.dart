import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../data/model/shippingv2_model.dart';
import '../../../data/repositories/pickingv2_repository.dart';
import '../../../domain/filter_tag_redirect.dart';

part 'picking_loadv2_state.dart';

class PickingLoadv2Cubit extends Cubit<PickingLoadv2State> {
  final Pickingv2Repository repository;
  PickingLoadv2Cubit(this.repository, String dateIni, String dateEnd)
      : super(PickingLoadv2Initial()) {
    fetchPickingLoads(dateIni, dateEnd);
  }

  void setRedirect(String load) {
    if (state is PickingLoadv2Loaded) {
      emit(PickingLoadv2Loading());
      emit(PickingLoadv2Redirect(load: load));
    }
  }

  void fetchPickingLoads(String dateIni, String dateEnd) async {
    emit(PickingLoadv2Loading());

    final data = await repository.fetchPickingLoadList(dateIni, dateEnd);

    data.fold((l) => emit(PickingLoadv2Error(error: l)),
        (r) => emit(PickingLoadv2Loaded(loads: r, load: '')));
  }

  void fetchPickingLoadsDeparment(
      String load, String deparment, String dateIni, String dateEnd) async {
    emit(PickingLoadv2Loading());

    final data = await repository.fetchPickingLoadList(dateIni, dateEnd);

    data.fold((l) => emit(PickingLoadv2Error(error: l)), (r) {
      if (deparment.trim() == "03") {
        final response =
            FilterTagRedirectUseCase.isDepartmentEndig(deparment, load, r);
        if (response) {
          emit(PickingLoadv2Loaded(loads: r, load: load));
          return;
        }
      }

      emit(PickingLoadv2Loaded(loads: r, load: ''));
    });
  }
}
