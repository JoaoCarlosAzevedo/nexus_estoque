import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';

import '../model/order_check_model.dart';

final orderCheckRepositoryProvider =
    Provider<OrderCheckRepository>((ref) => OrderCheckRepository(ref));

class OrderCheckRepository {
  late Dio dio;
  final Ref _ref;

  OrderCheckRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<Either<Failure, List<OrderCheckModel>>> fetchPedidos() async {
    final String url = await Config.baseURL;
    try {
      final response = await dio.get('$url/api/v2/conferencia/pedidos');

      if (response.statusCode != 200) {
        return const Left(Failure("Erro no servidor!", ErrorType.exception));
      }

      if (response.data == null) {
        return const Right([]);
      }

      final list = (response.data as List)
          .map((item) =>
              OrderCheckModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return Right(list);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const Left(Failure("Tempo excedido", ErrorType.timeout));
      }

      final message = e.response?.data != null &&
              e.response?.data is Map &&
              (e.response!.data as Map)['message'] != null
          ? (e.response!.data as Map)['message'].toString()
          : "Erro no servidor!";

      return Left(Failure(message, ErrorType.exception));
    }
  }

  Future<Either<Failure, Unit>> postConferencia(
    List<OrderCheckItemModel> itens,
  ) async {
    final String url = await Config.baseURL;
    final jsonList = itens
        .map((e) => {
              'recno': e.recno,
              'conferido': e.conferido,
            })
        .toList();

    try {
      final response = await dio.post(
        '$url/api/v2/conferencia/pedidos',
        data: jsonList,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        return const Left(Failure("Erro no servidor!", ErrorType.exception));
      }

      return const Right(unit);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const Left(Failure("Tempo excedido", ErrorType.timeout));
      }

      final message = e.response?.data != null &&
              e.response?.data is Map &&
              (e.response!.data as Map)['message'] != null
          ? (e.response!.data as Map)['message'].toString()
          : "Erro ao enviar conferência.";

      return Left(Failure(message, ErrorType.exception));
    }
  }
}
