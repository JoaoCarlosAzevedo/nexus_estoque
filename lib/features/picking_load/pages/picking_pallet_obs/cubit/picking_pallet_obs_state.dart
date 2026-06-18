part of 'picking_pallet_obs_cubit.dart';

enum PalletObsStatus { idle, sending, success, error }

class PickingPalletObsState extends Equatable {
  final List<PalletObsItem> items;
  final PalletObsStatus status;
  final String? errorMessage;
  final bool panelVisible;

  const PickingPalletObsState({
    this.items = const [],
    this.status = PalletObsStatus.idle,
    this.errorMessage,
    this.panelVisible = true,
  });

  PickingPalletObsState copyWith({
    List<PalletObsItem>? items,
    PalletObsStatus? status,
    String? errorMessage,
    bool? panelVisible,
  }) {
    return PickingPalletObsState(
      items: items ?? this.items,
      status: status ?? this.status,
      errorMessage: errorMessage,
      panelVisible: panelVisible ?? this.panelVisible,
    );
  }

  @override
  List<Object?> get props => [items, status, errorMessage, panelVisible];
}
