import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/constants/config.dart';
import 'package:nexus_estoque/core/constants/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';
import 'package:nexus_estoque/features/transaction/data/model/transaction_model.dart';

final transactionRepository =
    Provider<TransactionRepository>((ref) => TransactionRepository(ref));

class TransactionRepository {
  late Dio dio;
  final String url = Config.baseURL!;
  final Ref _ref;
  final options = DioConfig.dioBaseOption;

  TransactionRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<Either<Failure, TransactionModel>> postTransaction(
      TransactionModel transaction, String tm) async {
    try {
      var response = await dio.post('$url/movimentos',
          data: transaction.toJson(),
          queryParameters: {
            'empresa': "01",
            'filial': "01",
            'tm': tm,
          });

      if (response.data["message"] != null) {
        return Left(Failure(response.data["message"], ErrorType.validation));
      }

      if (response.statusCode == 201) {
        return Right(TransactionModel.fromMap(response.data));
      }

      return const Left(Failure("Server Error!", ErrorType.exception));
    } on DioError catch (e) {
      if (e.response!.data["message"] != null) {
        return Left(Failure(e.response!.data["message"], ErrorType.validation));
      }
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }
}
