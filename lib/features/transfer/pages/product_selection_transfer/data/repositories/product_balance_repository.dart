import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/constants/config.dart';
import 'package:nexus_estoque/core/constants/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/data/model/product_balance_model.dart';

final productBalanceRepository =
    Provider<ProductBalanceRepository>((ref) => ProductBalanceRepository(ref));

class ProductBalanceRepository {
  late Dio dio;
  final String url = Config.baseURL!;
  final options = DioConfig.dioBaseOption;
  final Ref _ref;

  ProductBalanceRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<Either<Failure, ProductBalanceModel>> fetchProductBalance(
      String barcode) async {
    late dynamic response;
    try {
      response = await dio.get('$url/produtos/saldos/', queryParameters: {
        'empresa': "01",
        'filial': "01",
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
    } on DioError catch (e) {
      log(e.type.name);
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }
}
