import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/searches/clients/data/model/client_model.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';

final clientRepository =
    Provider<ClientRepository>((ref) => ClientRepository(ref));

class ClientRepository {
  late Dio dio;
  final options = DioConfig.dioBaseOption;
  final Ref _ref;

  ClientRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<List<ClientModel>> fetchClients() async {
    final String url = await Config.baseURL;
    late dynamic response;
    try {
      response = await dio.get('$url/clientes/', queryParameters: {});

      if (response.statusCode != 200) {
        throw const Failure("Server Error!", ErrorType.exception);
      }

      if (response.data.isEmpty) {
        throw const Failure(
            "Nenhum registro encontrado.", ErrorType.validation);
      }

      final listClients = (response.data['resultado'] as List).map((item) {
        return ClientModel.fromMap(item);
      }).toList();

      return listClients;
    } on DioError catch (e) {
      log(e.type.name);
      return throw const Failure("Server Error!", ErrorType.exception);
    }
  }
}
