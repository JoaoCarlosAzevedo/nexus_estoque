import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';

import 'package:nexus_estoque/core/http/http_provider.dart';

import '../model/product_multiplier_model.dart';

final productMultiplierRepositoryProvider =
    Provider<ProductMultiplierRepository>(
        (ref) => ProductMultiplierRepository(ref));

class ProductMultiplierRepository {
  late Dio dio;
  final options = DioConfig.dioBaseOption;
  final Ref _ref;

  ProductMultiplierRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<ProductMultiplierModel> fechProductMultiplier(String barcode) async {
    late dynamic response;
    final String url = await Config.baseURL;

    try {
      response = await dio.get(
        '$url/produtos/detalhes/$barcode',
      );

      if (response.statusCode == 200) {
        return ProductMultiplierModel.fromMap(response.data);
      }

      throw const Failure("Nenhum registro encontrado.", ErrorType.validation);
    } on DioException catch (_) {
      throw const Failure("Erro desconhecido", ErrorType.validation);
    }
  }

  Future<bool> postProductMultiplier(ProductMultiplierModel product) async {
    late dynamic response;
    final String url = await Config.baseURL;
    try {
      response =
          await dio.post('$url/produtos/detalhes/', data: product.toJson());

      if (response.statusCode == 201) {
        return true;
      }

      throw const Failure("Erro ao gravar fator", ErrorType.validation);
    } on DioException catch (_) {
      throw const Failure("Erro desconhecido", ErrorType.validation);
    }
  }

  Future<bool> postProductBarcode(String product, String barcode) async {
    late dynamic response;
    final String url = await Config.baseURL;
    final data = {
      'produto': product,
      'barcode': barcode,
    };
    final String json = jsonEncode(data);

    try {
      response = await dio.post('$url/produtos/detalhes/', data: json);

      if (response.statusCode == 201) {
        return true;
      }

      throw const Failure("Erro ao gravar cód de barras", ErrorType.validation);
    } on DioException catch (e) {
      if (e.response!.data["message"] != "") {
        throw e.response!.data["message"];
      }
      throw "Erro desconhecido";
    }
  }
}
