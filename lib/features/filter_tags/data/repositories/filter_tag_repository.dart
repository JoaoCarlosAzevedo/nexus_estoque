import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/http/config.dart';
import '../../../../core/http/dio_config.dart';
import '../../../../core/http/http_provider.dart';
import '../model/filter_tag_load_model.dart';
import '../model/filter_tag_model.dart';

final filterTagRepositoryProvider =
    Provider<FilterTagRepository>((ref) => FilterTagRepository(ref));

class FilterTagRepository {
  late Dio dio;
  final Ref _ref;
  final options = DioConfig.dioBaseOption;

  FilterTagRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<Either<Failure, String>> postTag(Invoice invoice) async {
    final String url = await Config.baseURL;
    try {
      var response =
          await dio.post('$url/etiqueta_filtro', data: invoice.toJson());

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

  Future<Either<Failure, Load>> fetchLoad(String load) async {
    final String url = await Config.baseURL;
    try {
      var response = await dio.get('$url/etiqueta_filtro/carga/$load');

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        return const Left(Failure("Nao Encontrado!", ErrorType.validation));
      }
      final listRoutes = Load.fromMap(response.data);

      return Right(listRoutes);
    } on DioException catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }

  Future<Either<Failure, List<FilterTagModel>>> fetchAllTags(
      String nf, String serie) async {
    final String url = await Config.baseURL;
    try {
      var response = await dio.get('$url/etiqueta_filtro/', queryParameters: {
        'nf': nf,
        'serie': serie,
      });

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        return const Left(
            Failure("Nenhum registro encontrado!", ErrorType.validation));
      }

      final listTags = (response.data as List).map((item) {
        return FilterTagModel.fromMap(item);
      }).toList();

      return Right(listTags);
    } on DioException catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }

  Future<Either<Failure, String>> deleteTag(FilterTagModel tag) async {
    final String url = await Config.baseURL;
    try {
      var response = await dio.delete('$url/etiqueta_filtro', queryParameters: {
        'nf': tag.nf,
        'serie': tag.serie,
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
