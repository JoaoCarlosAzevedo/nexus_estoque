import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';

import '../model/etiqueta_nf_saida_model.dart';
import '../model/etiqueta_nf_saida_status_model.dart';

final etiquetaNfSaidaRepositoryProvider =
    Provider<EtiquetaNfSaidaRepository>((ref) => EtiquetaNfSaidaRepository(ref));

final etiquetaNfSaidaStatusProvider = FutureProvider.family
    .autoDispose<List<EtiquetaNfSaidaStatus>, String>((ref, range) async {
  final parts = range.split('|');
  final dataIni = parts.isNotEmpty ? parts[0] : '';
  final dataFim = parts.length > 1 ? parts[1] : dataIni;
  return ref
      .read(etiquetaNfSaidaRepositoryProvider)
      .fetchStatus(dataIni, dataFim);
});

final etiquetaNfSaidaDetailProvider = FutureProvider.family
    .autoDispose<EtiquetaNfSaida, String>((ref, chave) async {
  return ref.read(etiquetaNfSaidaRepositoryProvider).fetchEtiquetas(chave);
});

class EtiquetaNfSaidaRepository {
  late Dio dio;
  final Ref _ref;

  EtiquetaNfSaidaRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<List<EtiquetaNfSaidaStatus>> fetchStatus(
    String dataIni,
    String dataFim,
  ) async {
    final String url = await Config.baseURL;
    try {
      final response = await dio.get(
        '$url/conferencia_nf_saida/status',
        queryParameters: {
          'dataIni': dataIni,
          'dataFim': dataFim,
        },
      );

      if (response.statusCode != 200) {
        throw const Failure("Erro no servidor!", ErrorType.exception);
      }

      if (response.data == null) {
        return const [];
      }

      if (response.data is Map &&
          (response.data as Map)['mensagem'] != null) {
        throw Failure(
          (response.data as Map)['mensagem'].toString(),
          ErrorType.validation,
        );
      }

      final list = (response.data as List)
          .map((e) =>
              EtiquetaNfSaidaStatus.fromMap(e as Map<String, dynamic>))
          .toList();

      return list;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const Failure("Tempo excedido", ErrorType.timeout);
      }
      if (e.response?.statusCode == 400) {
        throw Failure(
          e.response?.data is Map
              ? (e.response?.data['message']?.toString() ??
                  'Requisição inválida')
              : 'Requisição inválida',
          ErrorType.validation,
        );
      }
      throw const Failure("Server Error!", ErrorType.exception);
    }
  }

  Future<EtiquetaNfSaida> fetchEtiquetas(String chave) async {
    final String url = await Config.baseURL;
    try {
      final response = await dio.get(
        '$url/api/v2/etiquetas/nf/saida',
        queryParameters: {
          'chave': chave,
        },
      );

      if (response.statusCode != 200) {
        throw const Failure("Erro no servidor!", ErrorType.exception);
      }

      if (response.data == null) {
        throw const Failure(
            "Nenhuma etiqueta encontrada.", ErrorType.validation);
      }

      if (response.data is Map &&
          (response.data as Map)['mensagem'] != null) {
        throw Failure(
          (response.data as Map)['mensagem'].toString(),
          ErrorType.validation,
        );
      }

      return EtiquetaNfSaida.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const Failure("Tempo excedido", ErrorType.timeout);
      }
      if (e.response?.statusCode == 400) {
        throw Failure(
          e.response?.data is Map
              ? (e.response?.data['message']?.toString() ??
                  'Requisição inválida')
              : 'Requisição inválida',
          ErrorType.validation,
        );
      }
      throw const Failure("Server Error!", ErrorType.exception);
    }
  }
}
