import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexus_estoque/core/error/failure.dart';

import '../model/product_address_model.dart';

class ProductAddressRepository {
  late Dio dio;

  final options = BaseOptions(
    baseUrl: 'http://10.0.2.2:8090/api/',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );

  ProductAddressRepository() {
    dio = Dio(options);
  }

  Future<Either<Failure, List<ProductAddress>>> fetchProductAddress() async {
    try {
      var response = await dio.get(
        'http://10.0.2.2:8090/api/collections/address_balance/records',
      );

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!"));
      }

      if (response.data.isEmpty) {
        return const Left(Failure("Nao Encontrado!"));
      }
      final listProducts = (response.data['items'] as List).map((item) {
        return ProductAddress.fromMap(item);
      }).toList();

      return Right(listProducts);
    } on DioError catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido"));
      }
      return const Left(Failure("Server Error!"));
    }
  }
}
