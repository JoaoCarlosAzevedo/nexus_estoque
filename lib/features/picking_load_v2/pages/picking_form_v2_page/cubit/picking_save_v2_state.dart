part of 'picking_save_v2_cubit.dart';

abstract class PickingSavev2State extends Equatable {
  const PickingSavev2State();

  @override
  List<Object> get props => [];
}

class PickingSavev2Initial extends PickingSavev2State {}

class PickingSavev2Loading extends PickingSavev2State {}

class PickingSavev2Error extends PickingSavev2State {
  final Failure failure;

  const PickingSavev2Error({
    required this.failure,
  });
}

class PickingSavev2Loaded extends PickingSavev2State {}
