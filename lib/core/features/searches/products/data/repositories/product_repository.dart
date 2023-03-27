import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';
import 'package:nexus_estoque/core/features/searches/products/data/model/product_model.dart';

final productRepositoryProvider =
    Provider<ProductRepository>((ref) => ProductRepository(ref));

class ProductRepository {
  late Dio dio;
  final Ref _ref;

  ProductRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  void cleanCache() async {}

  Future<List<ProductModel>> fetchProducts() async {
    late dynamic response;
    final String url = await Config.baseURL;
    try {
      response = await dio.get('$url/produtos/', queryParameters: {
        'page': "1",
        'pageSize': "10000",
      });

      if (response.statusCode != 200) {
        throw const Failure("Server Error!", ErrorType.exception);
      }

      if (response.data.isEmpty) {
        throw const Failure(
            "Nenhum registro encontrado.", ErrorType.validation);
      }

      final listProducts = (response.data['resultado'] as List).map((item) {
        return ProductModel.fromMap(item);
      }).toList();

      return listProducts;
    } on DioError catch (e) {
      log(e.type.name);
      return throw const Failure("Server Error!", ErrorType.exception);
    }
  }
}
