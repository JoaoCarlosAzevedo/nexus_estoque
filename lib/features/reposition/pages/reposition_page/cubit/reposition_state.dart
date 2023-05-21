part of 'reposition_cubit.dart';

abstract class RepositionState extends Equatable {
  const RepositionState();

  @override
  List<Object> get props => [];
}

class RepositionInitial extends RepositionState {}

class RepositionLoading extends RepositionState {}

class RepositionError extends RepositionState {
  final Failure error;
  const RepositionError({
    required this.error,
  });
}

class RepositionLoaded extends RepositionState {
  final List<RepositionModel> repositions;

  const RepositionLoaded({
    required this.repositions,
  });
}
