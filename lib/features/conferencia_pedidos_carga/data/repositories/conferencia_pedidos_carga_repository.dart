import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';

import '../model/conferencia_pedido_model.dart';

final conferenciaPedidosCargaRepositoryProvider =
    Provider<ConferenciaPedidosCargaRepository>(
        (ref) => ConferenciaPedidosCargaRepository(ref));

class ConferenciaPedidosCargaRepository {
  late Dio dio;
  final Ref _ref;

  ConferenciaPedidosCargaRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<Either<Failure, List<ConferenciaPedidoModel>>> fetchPedidos(
    String dataInicio,
    String dataFim,
  ) async {
    final String url = await Config.baseURL;
    try {
      final response = await dio.get(
        '$url/api/v2/conferencia/pedidos',
        queryParameters: {
          'dataInicio': dataInicio,
          'dataFim': dataFim,
        },
      );

      if (response.statusCode != 200) {
        final data = response.data;
        final message =
            data != null && data is Map && data['errorMessage'] != null
                ? data['errorMessage'].toString()
                : "Erro no servidor!";
        return Left(Failure(message, ErrorType.exception));
      }

      if (response.data == null) {
        return const Right([]);
      }

      final list = (response.data as List)
          .map((item) =>
              ConferenciaPedidoModel.fromJson(item as Map<String, dynamic>))
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
              (e.response!.data as Map)['errorMessage'] != null
          ? (e.response!.data as Map)['errorMessage'].toString()
          : "Erro no servidor!";

      return Left(Failure(message, ErrorType.exception));
    }
  }

  Future<Either<Failure, Unit>> postConferenciaCarga(
    List<ConferenciaPedidoModel> pedidos,
  ) async {
    final String url = await Config.baseURL;
    final conferencia = <Map<String, dynamic>>[];

    for (final pedido in pedidos) {
      for (final item in pedido.itens) {
        conferencia.add({
          'recno': item.recno,
          'conferido': item.conferido,
        });
      }
    }

    final data = {
      'pedido': '',
      'volumes': 0,
      'conferencia': conferencia,
    };

    try {
      final response = await dio.post(
        '$url/api/v2/conferencia/pedidos',
        data: data,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final responseData = response.data;
        final message = responseData != null &&
                responseData is Map &&
                responseData['errorMessage'] != null
            ? responseData['errorMessage'].toString()
            : "Erro no servidor!";
        return Left(Failure(message, ErrorType.exception));
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
              (e.response!.data as Map)['errorMessage'] != null
          ? (e.response!.data as Map)['errorMessage'].toString()
          : "Erro ao enviar conferência.";

      return Left(Failure(message, ErrorType.exception));
    }
  }
}
