import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nexus_estoque/core/http/http_provider.dart';

final importInvoiceRepositoryProvider =
    Provider<ImportInvoiceRepository>((ref) => ImportInvoiceRepository(ref));

class ImportInvoiceRepository {
  late Dio dio;
  final Ref _ref;

  ImportInvoiceRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<List<String>> fechtImportInvoice(
    String chave,
  ) async {
    //final String url = await Config.baseURL;
    //late dynamic response;

    await Future.delayed(const Duration(seconds: 4));
    return [];
/* 
    try {
      response = await dio.get('$url/lotes/', queryParameters: {
        'page': "1",
        'pageSize': "10000",
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

      return [];
    } on DioException catch (e) {
      log(e.message.toString());
      throw const Failure("Erro ao conectar!", ErrorType.exception);
    }

     */
  }
}
