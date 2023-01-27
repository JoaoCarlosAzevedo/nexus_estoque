import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/constants/config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/features/searches/batches/data/model/batch_model.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';

final batchRepositoryProvider =
    Provider<BatchRepository>((ref) => BatchRepository(ref));

class BatchRepository {
  late Dio dio;
  final String url = Config.baseURL!;
  final Ref _ref;

  BatchRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<List<BatchModel>> fetchBatches(
      String product, String warehouse) async {
    late dynamic response;
    try {
      response = await dio.get('$url/lotes/', queryParameters: {
        'empresa': "01",
        'filial': "01",
        'page': "1",
        'pageSize': "10000",
        'produto': product,
        'armazem': warehouse,
      });

      if (response.statusCode != 200) {
        throw const Failure("Erro ao conectar!", ErrorType.exception);
      }

      if (response.data.isEmpty) {
        throw const Failure("Nenhum registro encontrado.", ErrorType.exception);
      }

      if ((response.data['resultado'] as List).isEmpty) {
        throw const Failure(
            "Nenhum registro encontrado.", ErrorType.validation);
      }

      final batches = (response.data['resultado'] as List).map((item) {
        return BatchModel.fromMap(item);
      }).toList();

      return batches;
    } on DioError catch (e) {
      log(e.message);
      throw const Failure("Erro ao conectar!", ErrorType.exception);
    }
  }
}
