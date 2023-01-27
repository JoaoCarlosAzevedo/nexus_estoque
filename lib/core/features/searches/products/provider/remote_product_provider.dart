import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/searches/products/data/model/product_model.dart';
import 'package:nexus_estoque/core/features/searches/products/data/repositories/product_repository.dart';

final remoteProductProvider = FutureProvider<List<ProductModel>>((ref) async {
  final result = await ref.read(productRepositoryProvider).fetchProducts();
  return result;
});
