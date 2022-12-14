import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/constants/config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';
import 'package:nexus_estoque/core/pages/searches/products/data/model/product_search_model.dart';

final productSearchRepository =
    Provider<ProductSearchRepository>((ref) => ProductSearchRepository(ref));

class ProductSearchRepository {
  late Dio dio;
  final String url = Config.baseURL!;
  final Ref _ref;

  ProductSearchRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  void cleanCache() async {}

  Future<Either<Failure, List<ProductSearchModel>>> fetchProducts() async {
    late dynamic response;
    try {
      response = await dio.get('$url/produtos/', queryParameters: {
        'empresa': "01",
        'filial': "01",
        'page': "1",
        'pageSize': "10000",
      });

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        return const Left(
            Failure("Nenhum registro encontrado.", ErrorType.validation));
      }

      final listAddress = (response.data['resultado'] as List).map((item) {
        return ProductSearchModel.fromMap(item);
      }).toList();

      return Right(listAddress);
    } on DioError catch (e) {
      log(e.type.name);
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }
}
