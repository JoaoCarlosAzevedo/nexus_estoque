import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:nexus_estoque/core/constants/config.dart';
import 'package:nexus_estoque/core/constants/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/pages/searches/products/data/model/product_search_model.dart';

class ProductSearchRepository {
  late Dio dio;
  final String url = Config.baseURL!;
  final options = DioConfig.dioBaseOption;
  late DioCacheManager dioCacheManager;
  late Options cacheOptions;

  ProductSearchRepository() {
    dio = Dio(options);
    dioCacheManager = DioCacheManager(CacheConfig());
    cacheOptions = buildCacheOptions(const Duration(days: 7));
    dio.interceptors.add(dioCacheManager.interceptor);
  }

  Future<Either<Failure, List<ProductSearchModel>>> fetchAddress() async {
    late dynamic response;
    try {
      response = await dio.get('$url/produtos/',
          queryParameters: {
            'empresa': "01",
            'filial': "01",
            'page': "1",
            'pageSize': "10000",
          },
          options: cacheOptions);

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
