import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/searches/batches/data/model/batch_model.dart';
import 'package:nexus_estoque/core/features/searches/batches/data/repositories/batch_repository.dart';

final remoteBatchProvider = FutureProvider.family
    .autoDispose<List<BatchModel>, List<String>>((ref, args) async {
  final result =
      await ref.read(batchRepositoryProvider).fetchBatches(args[0], args[1]);
  return result;
});
