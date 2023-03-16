part of 'picking_save_cubit.dart';

abstract class PickingSaveState extends Equatable {
  const PickingSaveState();

  @override
  List<Object> get props => [];
}

class PickingSaveInitial extends PickingSaveState {}

class PickingSaveLoading extends PickingSaveState {}

class PickingSaveError extends PickingSaveState {
  final Failure failure;

  const PickingSaveError({
    required this.failure,
  });
}

class PickingSaveLoaded extends PickingSaveState {}
