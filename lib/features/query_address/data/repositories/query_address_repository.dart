import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/query_address/data/model/query_address_model.dart';

class QueryAddressRepository {
  final dio = Dio();

  Future<Either<Failure, List<QueryAddressModel>>> fetchAdress(
      String query) async {
    late dynamic response;
    try {
      //response = await dio.get('/test', queryParameters: {'id': 12, 'name': 'wendu'});
      if (query.isEmpty) {
        response = await dio.get(
            'http://10.0.2.2:8090/api/collections/address_location/records');
      } else {
        response = await dio.get(
            'http://10.0.2.2:8090/api/collections/address_location/records',
            queryParameters: {
              'filter': "(descricao~'${query}'||codigo~'${query}' )"
            });
      }

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!"));
      }

      if (response.data.isEmpty) {
        return const Left(Failure("Nao Encontrado!"));
      }
      final listProducts = (response.data['items'] as List).map((item) {
        return QueryAddressModel.fromMap(item);
      }).toList();

      return Right(listProducts);
    } on DioError catch (e) {
      log(e.type.name);
      return const Left(Failure("Server Error!"));
    }
  }
}
