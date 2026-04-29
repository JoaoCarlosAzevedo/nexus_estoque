import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/http/config.dart';
import '../../../../core/http/dio_config.dart';
import '../../../../core/http/http_provider.dart';
import '../model/etiqueta_filtro_pedido_completo_model.dart';
import '../model/etiqueta_pedido_v3_model.dart';
import '../model/filter_tag_load_order_model.dart';
import '../model/filter_tag_order_model.dart';

final filterTagRepositoryProvider =
    Provider<FilterTagRepository>((ref) => FilterTagRepository(ref));

final orderVolumesProvider =
    FutureProvider.family.autoDispose<Orders, String>((ref, args) async {
  final result =
      await ref.read(filterTagRepositoryProvider).fetchOrderVolumes(args);
  return result;
});

String _messageFromResponseData(dynamic data) {
  if (data == null) return '';
  if (data is Map) {
    for (final key in ['message', 'error', 'errorMessage', 'mensagem']) {
      final v = data[key];
      if (v != null && v.toString().trim().isNotEmpty) {
        return v.toString();
      }
    }
  }
  if (data is String && data.trim().isNotEmpty) {
    return data;
  }
  return '';
}

Failure _failureFromResponse(Response? response, {String fallback = 'Server Error!'}) {
  final msg = _messageFromResponseData(response?.data);
  if (msg.isNotEmpty) {
    final code = response?.statusCode ?? 500;
    return Failure(
      msg,
      code >= 400 && code < 500 ? ErrorType.validation : ErrorType.exception,
    );
  }
  return Failure(fallback, ErrorType.exception);
}

Failure _failureFromDio(DioException e, {String fallback = 'Server Error!'}) {
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    return const Failure('Tempo Excedido', ErrorType.timeout);
  }
  final msg = _messageFromResponseData(e.response?.data);
  if (msg.isNotEmpty) {
    final code = e.response?.statusCode ?? 500;
    return Failure(
      msg,
      code >= 400 && code < 500 ? ErrorType.validation : ErrorType.exception,
    );
  }
  if (e.message != null && e.message!.trim().isNotEmpty) {
    return Failure(e.message!, ErrorType.exception);
  }
  return Failure(fallback, ErrorType.exception);
}

class FilterTagRepository {
  late Dio dio;
  final Ref _ref;
  final options = DioConfig.dioBaseOption;

  FilterTagRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<Either<Failure, String>> postTag(Orders invoice) async {
    final String url = await Config.baseURL;
    try {
      var response = await dio.post('$url/etiqueta_filtro_pedidos',
          data: invoice.toJson());

      if (response.statusCode != 201) {
        return Left(_failureFromResponse(response));
      }

      if (response.data.isEmpty) {
        return const Left(
            Failure("Erro ao gerar etiqueta!", ErrorType.validation));
      }

      return Right(response.data['etiqueta']);
    } on DioException catch (e) {
      return Left(_failureFromDio(e));
    }
  }

  Future<Either<Failure, String>> postIndividualTag(Orders invoice) async {
    final String url = await Config.baseURL;
    try {
      var response = await dio.post('$url/etiqueta_filtro_pedidos/individual',
          data: invoice.toJson());

      if (response.statusCode != 201) {
        return Left(_failureFromResponse(response));
      }

      if (response.data.isEmpty) {
        return const Left(
            Failure("Erro ao gerar etiqueta!", ErrorType.validation));
      }

      return Right(response.data['etiqueta']);
    } on DioException catch (e) {
      return Left(_failureFromDio(e));
    }
  }

  Future<Either<Failure, List<EtiquetaPedidoV3Item>>> fetchPedidosByDateRange(
      String dtini, String dtfim) async {
    final String url = await Config.baseURL;
    try {
      final response = await dio.get(
        '$url/etiqueta_filtro_pedidos/pedidos',
        queryParameters: {
          'dtini': dtini,
          'dtfim': dtfim,
        },
      );

      if (response.statusCode != 200) {
        return Left(_failureFromResponse(response));
      }

      if (response.data == null) {
        return const Right([]);
      }

      final raw = response.data;
      if (raw is! List) {
        return Left(_failureFromResponse(response,
            fallback: 'Resposta inválida da API.'));
      }

      final list = raw
          .map((item) =>
              EtiquetaPedidoV3Item.fromMap(item as Map<String, dynamic>))
          .toList();

      return Right(list);
    } on DioException catch (e) {
      return Left(_failureFromDio(e));
    }
  }

  Future<Either<Failure, EtiquetaFiltroPedidoCompleto>> fetchPedidoCompleto(
      String pedido) async {
    final String url = await Config.baseURL;
    try {
      final response = await dio.get(
        '$url/etiqueta_filtro_pedidos/pedido/completo',
        queryParameters: {'pedido': pedido},
      );

      if (response.statusCode != 200) {
        return Left(_failureFromResponse(response));
      }

      final raw = response.data;
      if (raw == null || raw is! Map<String, dynamic>) {
        return Left(_failureFromResponse(response,
            fallback: 'Resposta inválida da API.'));
      }

      try {
        return Right(EtiquetaFiltroPedidoCompleto.fromMap(raw));
      } on ArgumentError catch (e) {
        return Left(Failure(
          e.message ?? e.toString(),
          ErrorType.validation,
        ));
      }
    } on DioException catch (e) {
      return Left(_failureFromDio(e));
    }
  }

  Future<Either<Failure, LoadOrder>> fetchLoad(String load) async {
    final String url = await Config.baseURL;
    final param = load.split("-");
    Response response;

    try {
      if (param.length == 1) {
        response = await dio.get('$url/etiqueta_filtro_pedidos/carga/$load');
      } else {
        response = await dio
            .get('$url/etiqueta_filtro_pedidos/carga/0', queryParameters: {
          'dtini': param[1],
          'dtfim': param[2],
          'tipo_etiqueta': param.length == 4 ? param[3] : '',
        });
      }

      if (response.statusCode != 200) {
        return Left(_failureFromResponse(response));
      }

      if (response.data.isEmpty) {
        return const Left(Failure("Nao Encontrado!", ErrorType.validation));
      }
      final listRoutes = LoadOrder.fromMap(response.data);

      return Right(listRoutes);
    } on DioException catch (e) {
      return Left(_failureFromDio(e));
    }
  }

  Future<Orders> fetchOrderVolumes(String order) async {
    final String url = await Config.baseURL;

    Response response;

    try {
      response = await dio
          .get('$url/etiqueta_filtro_pedidos/individual/', queryParameters: {
        'pedido': order,
      });

      if (response.statusCode != 200) {
        throw _failureFromResponse(response).error;
      }

      if (response.data.isEmpty) {
        throw "Nao Encontrado!";
      }
      final listRoutes = Orders.fromMap(response.data);

      return listRoutes;
    } on DioException catch (e) {
      throw _failureFromDio(e).error;
    }
  }

  Future<Either<Failure, List<FilterTagOrderModel>>> fetchAllTags(
      String pedido) async {
    final String url = await Config.baseURL;
    try {
      var response =
          await dio.get('$url/etiqueta_filtro_pedidos/', queryParameters: {
        'pedido': pedido,
      });

      if (response.statusCode != 200) {
        return Left(_failureFromResponse(response));
      }

      if (response.data.isEmpty) {
        return const Left(
            Failure("Nenhum registro encontrado!", ErrorType.validation));
      }

      final listTags = (response.data as List).map((item) {
        return FilterTagOrderModel.fromMap(item);
      }).toList();

      return Right(listTags);
    } on DioException catch (e) {
      return Left(_failureFromDio(e));
    }
  }

  Future<Either<Failure, String>> deleteTag(FilterTagOrderModel tag) async {
    final String url = await Config.baseURL;
    try {
      var response =
          await dio.delete('$url/etiqueta_filtro_pedidos', queryParameters: {
        'pedido': tag.pedido,
        'item': tag.embalagem,
      });

      if (response.statusCode != 200) {
        return Left(_failureFromResponse(response));
      }

      if (response.data.isEmpty) {
        return const Left(
            Failure("Erro ao excluir etiqueta!", ErrorType.validation));
      }

      //return Right( response.data['message'] );
      return const Right('deletado');
    } on DioException catch (e) {
      return Left(_failureFromDio(e));
    }
  }
}
