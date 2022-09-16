import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/query_address/data/model/query_address_model.dart';

class QueryAddressRepository {
  final dio = Dio();

  Future<Either<Failure, List<QueryAddressModel>>> fetchAdress() async {
    try {
      var response = await dio
          .get('http://10.0.2.2:8090/api/collections/address_location/records');

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
