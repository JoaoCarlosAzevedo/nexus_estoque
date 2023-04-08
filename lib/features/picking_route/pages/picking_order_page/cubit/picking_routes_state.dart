part of 'picking_routes_cubit.dart';

abstract class PickingRoutesState extends Equatable {
  const PickingRoutesState();

  @override
  List<Object> get props => [];
}

class PickingRoutesInitial extends PickingRoutesState {}

class PickingRoutesLoading extends PickingRoutesState {}

class PickingRoutesError extends PickingRoutesState {
  final Failure error;

  const PickingRoutesError(this.error);
}

class PickingRoutesLoaded extends PickingRoutesState {
  final List<PickingRouteModel> pickingRoutes;
  const PickingRoutesLoaded(this.pickingRoutes);
}
