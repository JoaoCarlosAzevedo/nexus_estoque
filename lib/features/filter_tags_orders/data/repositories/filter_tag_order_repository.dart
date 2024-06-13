import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/http/config.dart';
import '../../../../core/http/dio_config.dart';
import '../../../../core/http/http_provider.dart';
import '../model/filter_tag_load_order_model.dart';
import '../model/filter_tag_order_model.dart';

final filterTagRepositoryProvider =
    Provider<FilterTagRepository>((ref) => FilterTagRepository(ref));

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
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        return const Left(
            Failure("Erro ao gerar etiqueta!", ErrorType.validation));
      }

      return Right(response.data['etiqueta']);
    } on DioException catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }

  Future<Either<Failure, LoadOrder>> fetchLoad(String load) async {
    final String url = await Config.baseURL;
    try {
      var response = await dio.get('$url/etiqueta_filtro_pedidos/carga/$load');

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        return const Left(Failure("Nao Encontrado!", ErrorType.validation));
      }
      final listRoutes = LoadOrder.fromMap(response.data);

      return Right(listRoutes);
    } on DioException catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
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
        return const Left(Failure("Server Error!", ErrorType.exception));
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
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
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
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        return const Left(
            Failure("Erro ao excluir etiqueta!", ErrorType.validation));
      }

      //return Right( response.data['message'] );
      return const Right('deletado');
    } on DioException catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }
}
