import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexus_estoque/core/constants/config.dart';
import 'package:nexus_estoque/core/constants/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/pages/searches/warehouses/data/model/warehouse_search_model.dart';

class WarehouseSearchRepository {
  late Dio dio;
  final String url = Config.baseURL!;
  final options = DioConfig.dioBaseOption;

  WarehouseSearchRepository() {
    dio = Dio(options);
  }

  Future<Either<Failure, List<WarehouseModel>>> fetchWarehouses() async {
    late dynamic response;
    try {
      response = await dio.get('$url/armazens/', queryParameters: {
        'empresa': "01",
        'filial': "01",
      });

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        return const Left(
            Failure("Nenhum registro encontrado.", ErrorType.validation));
      }

      final listWarehouses = (response.data['resultado'] as List).map((item) {
        return WarehouseModel.fromMap(item);
      }).toList();

      return Right(listWarehouses);
    } on DioError catch (e) {
      log(e.type.name);
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }
}
