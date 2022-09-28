import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexus_estoque/core/constants/config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/query_address/data/model/query_address_model.dart';

class QueryAddressRepository {
  late Dio dio;
  final String url = Config.baseURL!;
  final options = BaseOptions(
    baseUrl: Config.baseURL!,
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );

  QueryAddressRepository() {
    dio = Dio(options);
  }

  Future<Either<Failure, List<QueryAddressModel>>> fetchAdress(
      String query) async {
    late dynamic response;
    try {
      //response = await dio.get('/test', queryParameters: {'id': 12, 'name': 'wendu'});
      if (query.isEmpty) {
        response =
            await dio.get('$url/enderecamentos/enderecos', queryParameters: {
          'empresa': "01",
          'filial': "01",
          'page': "1",
          'pageSize': "10000",
        });
      } else {
        response =
            await dio.get('$url/enderecamentos/enderecos', queryParameters: {
          'empresa': "01",
          'filial': "01",
          'page': "1",
          'pageSize': "10000",
        });
      }

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!"));
      }

      if (response.data.isEmpty) {
        return const Left(Failure("Nao Encontrado!"));
      }
      final listProducts = (response.data['resultado'] as List).map((item) {
        return QueryAddressModel.fromMap(item);
      }).toList();

      return Right(listProducts);
    } on DioError catch (e) {
      log(e.type.name);
      return const Left(Failure("Server Error!"));
    }
  }
}
