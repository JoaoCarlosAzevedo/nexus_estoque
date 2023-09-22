import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';

import '../model/inventory_product_model.dart';

final inventoryRepository =
    Provider<InventoryRepository>((ref) => InventoryRepository(ref));

class InventoryRepository {
  late Dio dio;
  final Ref _ref;
  final options = DioConfig.dioBaseOption;

  InventoryRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<List<InventoryProductModel>> postInventory(String json) async {
    final String url = await Config.baseURL;
    try {
      var response = await dio.post(
        '$url/inventario',
        data: json,
      );

      if (response.statusCode == 201) {
        final listProds = (response.data as List).map((item) {
          return InventoryProductModel.fromMap(item);
        }).toList();
        return listProds;
      }
      throw const Failure("Nenhum registro encontrado.", ErrorType.validation);
    } on DioError catch (_) {
      throw const Failure("Erro de conexão.", ErrorType.exception);
    }
  }
}
