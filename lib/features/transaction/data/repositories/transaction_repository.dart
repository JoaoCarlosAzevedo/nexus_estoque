import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';
import 'package:nexus_estoque/features/transaction/data/model/transaction_model.dart';

final transactionRepository =
    Provider<TransactionRepository>((ref) => TransactionRepository(ref));

class TransactionRepository {
  late Dio dio;
  final Ref _ref;
  final options = DioConfig.dioBaseOption;

  TransactionRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<Either<Failure, TransactionModel>> postTransaction(
      TransactionModel transaction, String tm) async {
    final String url = await Config.baseURL;

    try {
      var response = await dio.post('$url/movimentos',
          data: transaction.toJson(),
          queryParameters: {
            'tm': tm,
          });

      if (response.data["message"] != null) {
        return Left(Failure(response.data["message"], ErrorType.validation));
      }

      if (response.statusCode == 201) {
        return Right(TransactionModel.fromMap(response.data));
      }

      return const Left(Failure("Server Error!", ErrorType.exception));
    } on DioException catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }

      if (e.response!.data["message"] != null) {
        return Left(Failure(e.response!.data["message"], ErrorType.validation));
      }

      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }
}
