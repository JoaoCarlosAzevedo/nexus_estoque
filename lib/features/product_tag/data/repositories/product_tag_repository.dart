import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/http/config.dart';
import '../../../../core/http/dio_config.dart';
import '../../../../core/http/http_provider.dart';
import '../model/product_tag_model.dart';

final productTagRepositoryProvider =
    Provider<ProductTagRepository>((ref) => ProductTagRepository(ref));

final remoteProductTagProvider = FutureProvider.family
    .autoDispose<ProductTagModel, String>((ref, args) async {
  final result =
      await ref.read(productTagRepositoryProvider).getProductTag(args);
  return result;
});

class ProductTagRepository {
  late Dio dio;
  final Ref _ref;
  final options = DioConfig.dioBaseOption;

  ProductTagRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<ProductTagModel> getProductTag(String productCode) async {
    final String url = await Config.baseURL;

    try {
      var response = await dio.get('$url/produtos/etiqueta/', queryParameters: {
        'barcode': productCode,
      });

      if (response.statusCode != 200) {
        throw Exception('Server Error!');
      }

      return ProductTagModel.fromMap(response.data);
    } on Error catch (_) {
      throw Exception('Server Error!');
    }
  }
}

///produtos/etiqueta