import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexus_estoque/core/constants/config.dart';
import 'package:nexus_estoque/core/constants/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';

class ProductTransferRepository {
  late Dio dio;
  final String url = Config.baseURL!;
  final options = DioConfig.dioBaseOption;

  ProductTransferRepository() {
    dio = Dio(options);
  }

  Future<Either<Failure, String>> postTransfer(String json) async {
    try {
      late dynamic response;
      response =
          await dio.post('$url/transferencias/', data: json, queryParameters: {
        'empresa': "01",
        'filial': "01",
      });

      if (response.statusCode != 201) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data["message"] != null) {
        return Left(Failure(response.data["message"], ErrorType.validation));
      }

      return const Right("success");
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        return Left(Failure(e.response?.data["message"], ErrorType.validation));
      }

      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }
}
