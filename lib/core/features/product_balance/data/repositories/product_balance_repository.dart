import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';

final productBalanceRepositoryProvider = Provider<ProductBalanceRepositoryv2>(
    (ref) => ProductBalanceRepositoryv2(ref));

final productBalancetProvider =
    FutureProvider.family<ProductBalanceModel, String>((ref, args) async {
  final result = await ref
      .read(productBalanceRepositoryProvider)
      .fetchProductBalance(args);
  late ProductBalanceModel productBalance;
  result.fold((l) {
    throw Exception(l.error);
  }, (r) {
    productBalance = r;
  });

  return productBalance;
});

class ProductBalanceRepositoryv2 {
  late Dio dio;
  final options = DioConfig.dioBaseOption;
  final Ref _ref;

  ProductBalanceRepositoryv2(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<Either<Failure, ProductBalanceModel>> fetchProductBalance(
      String barcode) async {
    late dynamic response;
    final String url = await Config.baseURL;
    try {
      response = await dio.get('$url/produtos/saldos/', queryParameters: {
        'barcode': barcode,
      });

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        return const Left(
            Failure("Nenhum registro encontrado.", ErrorType.validation));
      }

      if (response.data["message"] != null) {
        return Left(Failure(response.data["message"], ErrorType.validation));
      }

      final productBalance = ProductBalanceModel.fromMap(response.data);

      return Right(productBalance);
    } on DioException catch (e) {
      log(e.type.name);
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }
}
