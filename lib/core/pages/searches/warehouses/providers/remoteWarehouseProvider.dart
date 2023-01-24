import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/pages/searches/warehouses/data/model/warehouse_search_model.dart';
import 'package:nexus_estoque/core/pages/searches/warehouses/data/repositories/warehouse_search_repository.dart';

final configProvider =
    FutureProvider<Either<Failure, List<WarehouseModel>>>((ref) async {
  final repository = ref.read(warehouseSearchRepository);
  final result = await repository.fetchWarehouses();
  return result;
});
