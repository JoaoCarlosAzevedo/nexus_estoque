import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/searches/warehouses/data/model/warehouse_model.dart';
import 'package:nexus_estoque/core/features/searches/warehouses/data/repositories/warehouse_repository.dart';

final remoteWarehouseProvider =
    FutureProvider<List<WarehouseModel>>((ref) async {
  final repository = ref.read(warehouseRepository);
  final result = await repository.fetchWarehouses();
  return result;
});
