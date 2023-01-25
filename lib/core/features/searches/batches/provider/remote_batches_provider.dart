import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/searches/batches/data/model/batch_model.dart';
import 'package:nexus_estoque/core/features/searches/batches/data/repositories/batch_search_repository.dart';

final remoteBatchProvider = FutureProvider<List<BatchModel>>((ref) async {
  final result = await ref.read(batchRepositoryProvider).fetchBatches();
  return result;
});
