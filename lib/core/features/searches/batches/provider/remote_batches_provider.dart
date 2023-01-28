import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/searches/batches/data/model/batch_model.dart';
import 'package:nexus_estoque/core/features/searches/batches/data/model/product_arg_model.dart';
import 'package:nexus_estoque/core/features/searches/batches/data/repositories/batch_repository.dart';

final remoteBatchProvider = FutureProvider.family
    .autoDispose<List<BatchModel>, ProductArg>((ref, args) async {
  final result = await ref
      .read(batchRepositoryProvider)
      .fetchBatches(args.product, args.warehouse);
  return result;
});
