import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../product_multiplier/data/repositories/product_multiplier_repository.dart';

final productBarcodeUpdateChangeProvider =
    AutoDisposeAsyncNotifierProvider<ProductBarcodeUpdateChangeProvider, bool>(
        () {
  return ProductBarcodeUpdateChangeProvider();
});

class ProductBarcodeUpdateChangeProvider
    extends AutoDisposeAsyncNotifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<void> postBarcode(String product, String barcode) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(productMultiplierRepositoryProvider);
      return await repository.postProductBarcode(product, barcode);
    });
  }
}
