import 'dart:async';

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
    AsyncNotifierProvider.autoDispose<ProductMultiplierChangeProvider, bool>(
  ProductMultiplierChangeProvider.new,
);

class ProductMultiplierChangeProvider extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() => false;

  Future<void> postMultiplier(ProductMultiplierModel product) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(productMultiplierRepositoryProvider);
      return await repository.postProductMultiplier(product);
    });
  }
}
