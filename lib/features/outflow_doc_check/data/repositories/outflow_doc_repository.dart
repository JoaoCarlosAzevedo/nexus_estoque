import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/dio_config.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';
import 'package:nexus_estoque/features/outflow_doc_check/data/model/outflow_doc_model.dart';

import '../../../filter_tags/data/model/filter_tag_model.dart';

final outflowDocRepository =
    Provider<OutflowDocRepository>((ref) => OutflowDocRepository(ref));

class OutflowDocRepository {
  late Dio dio;
  final Ref _ref;
  final options = DioConfig.dioBaseOption;

  OutflowDocRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<Either<Failure, OutFlowDoc>> fetchOutflowDoc(String search) async {
    final String url = await Config.baseURL;
    try {
      var response =
          await dio.get('$url/conferencia_nf_saida', queryParameters: {
        'pesquisa': search.trim(),
      });

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data["mensagem"] == "Nenhuma NF encontrada!") {
        return const Left(
            Failure("Nenhuma NF encontrada!", ErrorType.validation));
      }
      return Right(OutFlowDoc.fromMap(response.data));
    } on DioException catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }

  Future<Either<Failure, OutFlowDoc>> postOutFlowDoc(OutFlowDoc doc) async {
    final String url = await Config.baseURL;
    try {
      var response = await dio.post(
        '$url/conferencia_nf_saida',
        data: doc.toJson(),
      );

      if (response.data["mensagem"] == "Nenhum registro alterado!") {
        return const Left(
            Failure("Nenhuma NF encontrada!", ErrorType.validation));
      }

      if (response.statusCode != 201) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      return Right(OutFlowDoc.fromMap(response.data));
    } on DioException catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }

  Future<Either<Failure, List<FilterTagProductModel>>> fetchFilterTag(
      String qrcode) async {
    final String url = await Config.baseURL;
    try {
      var response = await dio.get('$url/etiqueta_filtro/', queryParameters: {
        'qrcode': qrcode,
      });

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        return const Left(
            Failure("Nenhum registro encontrado!", ErrorType.validation));
      }

      final listTags = (response.data as List).map((item) {
        return FilterTagProductModel.fromMap(item);
      }).toList();

      return Right(listTags);
    } on DioException catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }
}
