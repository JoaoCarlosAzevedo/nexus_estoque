import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexus_estoque/core/constants/config.dart';
import 'package:nexus_estoque/core/error/failure.dart';

import '../model/product_address_model.dart';

class ProductAddressRepository {
  late Dio dio;
  final String url = Config.baseURL!;

  final options = BaseOptions(
    baseUrl: Config.baseURL!,
    connectTimeout: 5000,
    receiveTimeout: 9000,
  );

  ProductAddressRepository() {
    dio = Dio(options);
  }

  Future<Either<Failure, List<ProductAddress>>> fetchProductAddress() async {
    try {
      var response = await dio.get('$url/enderecamentos', queryParameters: {
        'empresa': "01",
        'filial': "01",
        'page': "1",
        'pageSize': "10000",
      });

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!"));
      }

      if (response.data.isEmpty) {
        return const Left(Failure("Nao Encontrado!"));
      }
      final listProducts = (response.data['resultado'] as List).map((item) {
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

  Future<Either<Failure, String>> addressProduct(
      String produto, String codeseq, String endereco, double quantity) async {
    try {
      final jsonMap = {
        'produto': produto,
        'numseq': codeseq,
        'endereco': endereco,
        'quantidade': quantity,
      };

      final json = jsonEncode(jsonMap);

      var response =
          await dio.post('$url/enderecamentos', data: json, queryParameters: {
        'empresa': "01",
        'filial': "01",
      });

      if (response.statusCode != 201) {
        return const Left(Failure("Server Error!"));
      }

      if (response.data.isEmpty) {
        return const Left(Failure("Nao Encontrado!"));
      }

      return const Right("Created");
    } on DioError catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido"));
      }

      if (e.response!.data["message"] != "") {
        return Left(Failure(e.response!.data["message"]));
      }

      return const Left(Failure("Server Error!"));
    }
  }
}
