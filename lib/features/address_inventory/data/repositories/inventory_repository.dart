import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';

import '../model/inventory_model.dart';
import '../model/inventory_product_model.dart';

final inventoryRepository =
    Provider<InventoryRepository>((ref) => InventoryRepository(ref));

final remoteGetInventoryProvider = FutureProvider.autoDispose
    .family<List<InventoryModel>, String>((ref, param) async {
  final DateFormat formatter = DateFormat('yyyyMMdd');
  final String date = formatter.format(DateTime.now());
  final repository = ref.read(inventoryRepository);
  return repository.getInventory(date, param);
});

final remoteDeleteInventoryProvider =
    FutureProvider.autoDispose.family<bool, int>((ref, param) async {
  final repository = ref.read(inventoryRepository);
  return repository.deleteInventory(param);
});

class InventoryRepository {
  late Dio dio;
  final Ref _ref;
  final options = DioConfig.dioBaseOption;

  InventoryRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<bool> deleteInventory(int recno) async {
    final String url = await Config.baseURL;
    try {
      var response = await dio.delete(
        '$url/inventario/${recno.toString()}',
      );

      if (response.statusCode == 200) {
        if (response.data["status"] == "Registro deletado!") {
          return true;
        }

        return false;
      }
      throw const Failure("Nenhum registro encontrado.", ErrorType.validation);
    } on DioError catch (_) {
      throw const Failure("Erro de conexão.", ErrorType.exception);
    }
  }

  Future<List<InventoryModel>> getInventory(String date, String address) async {
    final String url = await Config.baseURL;
    final param = address.split('|');
    try {
      var response = await dio.get(
        '$url/inventario',
        queryParameters: {
          'emissao': date,
          'endereco': param[0],
          'Doc': param[1]
        },
      );

      if (response.statusCode == 200) {
        final listProds = (response.data as List).map((item) {
          return InventoryModel.fromMap(item);
        }).toList();
        return listProds;
      }
      throw const Failure("Nenhum registro encontrado.", ErrorType.validation);
    } on DioError catch (_) {
      throw const Failure("Erro de conexão.", ErrorType.exception);
    }
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
