part of 'picking_cubit.dart';

abstract class PickingCubitState extends Equatable {
  const PickingCubitState();

  @override
  List<Object> get props => [];
}

class PickingCubitInitial extends PickingCubitState {}

class PickingCubitLoading extends PickingCubitState {}

class PickingCubitError extends PickingCubitState {
  final Failure failure;

  const PickingCubitError({
    required this.failure,
  });
}

class PickingCubiLoaded extends PickingCubitState {
  final List<PickingModel> pickingList;
  const PickingCubiLoaded(this.pickingList);
}
