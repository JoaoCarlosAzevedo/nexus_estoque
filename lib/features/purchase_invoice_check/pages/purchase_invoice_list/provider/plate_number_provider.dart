import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/purchase_invoice_model.dart';
import '../../../data/repositories/purchase_invoice_repository.dart';

final plateNumberProvider =
    AsyncNotifierProvider.autoDispose<PlateNumberProvider, bool?>(
  PlateNumberProvider.new,
);

class PlateNumberProvider extends AsyncNotifier<bool?> {
  @override
  FutureOr<bool?> build() => null;

  Future<void> postPlateNumber(
      String plateNumber, List<PurchaseInvoice> invoices) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(purchaseInvoiceRepositoryProvider);
      return await repository.postPlateNumber(plateNumber, invoices);
    });
  }
}
