import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';
import 'package:nexus_estoque/core/features/searches/warehouses/data/model/warehouse_model.dart';

final warehouseRepository =
    Provider<WarehouseRepository>((ref) => WarehouseRepository(ref));

class WarehouseRepository {
  late Dio dio;
  final options = DioConfig.dioBaseOption;
  final Ref _ref;

  WarehouseRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<List<WarehouseModel>> fetchWarehouses() async {
    final String url = await Config.baseURL;
    late dynamic response;
    try {
      response = await dio.get('$url/armazens/', queryParameters: {});

      if (response.statusCode != 200) {
        throw const Failure("Server Error!", ErrorType.exception);
      }

      if (response.data.isEmpty) {
        throw const Failure(
            "Nenhum registro encontrado.", ErrorType.validation);
      }

      final listWarehouses = (response.data['resultado'] as List).map((item) {
        return WarehouseModel.fromMap(item);
      }).toList();

      return listWarehouses;
    } on DioException catch (e) {
      log(e.type.name);
      return throw const Failure("Server Error!", ErrorType.exception);
    }
  }
}
