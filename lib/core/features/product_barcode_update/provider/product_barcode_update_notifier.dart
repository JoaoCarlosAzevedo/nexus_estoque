import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../product_multiplier/data/repositories/product_multiplier_repository.dart';

final productBarcodeUpdateChangeProvider =
    AsyncNotifierProvider.autoDispose<ProductBarcodeUpdateChangeProvider, bool>(
  ProductBarcodeUpdateChangeProvider.new,
);

class ProductBarcodeUpdateChangeProvider extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() => false;

  Future<void> postBarcode(String product, String barcode) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(productMultiplierRepositoryProvider);
      return await repository.postProductBarcode(product, barcode);
    });
  }
}
