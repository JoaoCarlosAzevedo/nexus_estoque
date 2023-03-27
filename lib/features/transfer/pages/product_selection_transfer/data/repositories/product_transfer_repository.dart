import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';

final productTransferRepository = Provider<ProductTransferRepository>(
    (ref) => ProductTransferRepository(ref));

class ProductTransferRepository {
  late Dio dio;
  final options = DioConfig.dioBaseOption;
  final Ref _ref;

  ProductTransferRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<Either<Failure, String>> postTransfer(String json) async {
    final String url = await Config.baseURL;
    try {
      late dynamic response;
      response = await dio.post('$url/transferencias/', data: json);

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
