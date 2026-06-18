import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../picking_route/data/repositories/picking_route_repository.dart';
import '../../../data/model/pallet_obs_item.dart';

part 'picking_pallet_obs_state.dart';

class PickingPalletObsCubit extends Cubit<PickingPalletObsState> {
  final PickingRouteRepository repository;

  PickingPalletObsCubit(this.repository) : super(const PickingPalletObsState());

  void addItem({
    required String pedido,
    required String codigo,
    required String descricao,
    required double quantidade,
  }) {
    if (pedido.trim().isEmpty || codigo.trim().isEmpty) {
      return;
    }

    final existingIndex = state.items.indexWhere(
      (e) => e.pedido == pedido && e.codigo == codigo,
    );

    final List<PalletObsItem> updatedItems;
    if (existingIndex >= 0) {
      updatedItems = [...state.items];
      final existing = updatedItems[existingIndex];
      updatedItems[existingIndex] = existing.copyWith(
        descricao: descricao.isNotEmpty ? descricao : existing.descricao,
        quantidade: existing.quantidade + quantidade,
      );
    } else {
      updatedItems = [
        ...state.items,
        PalletObsItem(
          pedido: pedido,
          codigo: codigo,
          descricao: descricao,
          quantidade: quantidade,
        ),
      ];
    }

    emit(state.copyWith(
      items: updatedItems,
      status: PalletObsStatus.idle,
      errorMessage: null,
      panelVisible: true,
    ));
  }

  void removeItem(PalletObsItem item) {
    final updated = state.items
        .where((e) => !(e.pedido == item.pedido && e.codigo == item.codigo))
        .toList();
    emit(state.copyWith(
      items: updated,
      status: PalletObsStatus.idle,
      errorMessage: null,
    ));
  }

  void hidePanel() {
    emit(state.copyWith(panelVisible: false));
  }

  void showPanel() {
    emit(state.copyWith(panelVisible: true));
  }

  void clear() {
    emit(const PickingPalletObsState());
  }

  Future<void> sendObservacao(String observacao) async {
    if (state.items.isEmpty) {
      emit(state.copyWith(
        status: PalletObsStatus.error,
        errorMessage: "Nenhum item separado para enviar.",
      ));
      return;
    }

    if (observacao.trim().isEmpty) {
      emit(state.copyWith(
        status: PalletObsStatus.error,
        errorMessage: "Informe a observação do pallet.",
      ));
      return;
    }

    emit(state.copyWith(
      status: PalletObsStatus.sending,
      errorMessage: null,
    ));

    final result = await repository.postPalletObservacao(
      items: state.items,
      observacao: observacao,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: PalletObsStatus.error,
        errorMessage: failure.error,
      )),
      (_) => emit(const PickingPalletObsState(
        status: PalletObsStatus.success,
      )),
    );
  }

  void resetStatus() {
    if (state.status != PalletObsStatus.idle) {
      emit(state.copyWith(
        status: PalletObsStatus.idle,
        errorMessage: null,
      ));
    }
  }
}
