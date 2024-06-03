// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'picking_loadv2_cubit.dart';

class PickingLoadv2State extends Equatable {
  const PickingLoadv2State();

  @override
  List<Object> get props => [];
}

class PickingLoadv2Initial extends PickingLoadv2State {}

class PickingLoadv2Redirect extends PickingLoadv2State {
  final String load;
  const PickingLoadv2Redirect({
    required this.load,
  });
}

class PickingLoadv2Loading extends PickingLoadv2State {}

class PickingLoadv2Loaded extends PickingLoadv2State {
  final List<Shippingv2Model> loads;
  final String load;

  const PickingLoadv2Loaded({required this.loads, required this.load});
}

class PickingLoadv2Error extends PickingLoadv2State {
  final Failure error;

  const PickingLoadv2Error({
    required this.error,
  });
}
