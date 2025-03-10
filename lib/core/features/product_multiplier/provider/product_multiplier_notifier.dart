import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/product_multiplier_model.dart';
import '../data/repositories/product_multiplier_repository.dart';

final remoteProductMultiplierProvider = FutureProvider.family
    .autoDispose<ProductMultiplierModel, String>((ref, args) async {
  final result = await ref
      .read(productMultiplierRepositoryProvider)
      .fechProductMultiplier(args);
  return result;
});

final productMultiplierChangeProvider =
    AutoDisposeAsyncNotifierProvider<ProductMultiplierChangeProvider, bool>(() {
  return ProductMultiplierChangeProvider();
});

class ProductMultiplierChangeProvider extends AutoDisposeAsyncNotifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<void> postMultiplier(ProductMultiplierModel product) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(productMultiplierRepositoryProvider);
      return await repository.postProductMultiplier(product);
    });
  }
}
