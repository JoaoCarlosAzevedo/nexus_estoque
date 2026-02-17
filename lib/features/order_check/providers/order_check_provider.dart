import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/order_check_model.dart';
import '../data/repositories/order_check_repository.dart';

final orderCheckProvider =
    AsyncNotifierProvider.autoDispose<OrderCheckListNotifier,
        List<OrderCheckModel>>(OrderCheckListNotifier.new);

class OrderCheckListNotifier
    extends AutoDisposeAsyncNotifier<List<OrderCheckModel>> {
  @override
  Future<List<OrderCheckModel>> build() async {
    final repository = ref.read(orderCheckRepositoryProvider);
    final result = await repository.fetchPedidos();
    return result.fold(
      (failure) => throw Exception(failure.error),
      (pedidos) => pedidos,
    );
  }
}
