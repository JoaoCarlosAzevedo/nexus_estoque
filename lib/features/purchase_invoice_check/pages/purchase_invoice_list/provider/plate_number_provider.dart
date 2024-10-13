import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/purchase_invoice_model.dart';
import '../../../data/repositories/purchase_invoice_repository.dart';

final plateNumberProvider =
    AutoDisposeAsyncNotifierProvider<PlateNumberProvider, bool?>(() {
  return PlateNumberProvider();
});

class PlateNumberProvider extends AutoDisposeAsyncNotifier<bool?> {
  @override
  bool? build() {
    return null;
  }

  Future<void> postPlateNumber(
      String plateNumber, List<PurchaseInvoice> invoices) async {
    state = const AsyncValue.loading();
    // Add the new todo and reload the todo list from the remote repository
    state = await AsyncValue.guard(() async {
      final repository = ref.read(purchaseInvoiceRepositoryProvider);
      return await repository.postPlateNumber(plateNumber, invoices);
    });
  }
}
