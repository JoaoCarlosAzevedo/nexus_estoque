// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'picking_load_cubit.dart';

class PickingLoadState extends Equatable {
  const PickingLoadState();

  @override
  List<Object> get props => [];
}

class PickingLoadInitial extends PickingLoadState {}

class PickingLoadLoading extends PickingLoadState {}

class PickingLoadLoaded extends PickingLoadState {
  final List<ShippingModel> loads;

  const PickingLoadLoaded({required this.loads});
}

class PickingLoadError extends PickingLoadState {
  final Failure error;
  const PickingLoadError({
    required this.error,
  });
}
