import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nexus_estoque/core/http/http_provider.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/http/config.dart';

final importInvoiceRepositoryProvider =
    Provider<ImportInvoiceRepository>((ref) => ImportInvoiceRepository(ref));

class ImportInvoiceRepository {
  late Dio dio;
  final Ref _ref;

  ImportInvoiceRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<dynamic> fechtImportInvoice(
    String chave,
  ) async {
    final String url = await Config.baseURL;
    late dynamic response;

    try {
      response = await dio.post('$url/import_nf_entrada/$chave');

      if (response.statusCode != 201) {
        throw const Failure("Erro ao conectar!", ErrorType.exception);
      }
      // "mensagem": "NF incluida com sucesso!"

      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw e.response?.data["message"];
      }

      throw const Failure("Erro ao conectar!", ErrorType.exception);
    }
  }
}
