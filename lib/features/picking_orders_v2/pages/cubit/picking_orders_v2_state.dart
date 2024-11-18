// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'picking_orders_v2_cubit.dart';

class PickingOrdersV2State extends Equatable {
  const PickingOrdersV2State();

  @override
  List<Object> get props => [];
}

class PickingOrdersV2Initial extends PickingOrdersV2State {}

class PickingOrdersV2Redirect extends PickingOrdersV2State {
  final String load;
  const PickingOrdersV2Redirect({
    required this.load,
  });
}

class PickingOrdersV2Loading extends PickingOrdersV2State {}

class PickingOrdersV2Loaded extends PickingOrdersV2State {
  final List<Pickingv2Model> loads;
  final String load;

  const PickingOrdersV2Loaded({required this.loads, required this.load});
}

class PickingOrdersV2Error extends PickingOrdersV2State {
  final Failure error;

  const PickingOrdersV2Error({
    required this.error,
  });
}
