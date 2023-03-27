import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';
import 'package:nexus_estoque/core/features/searches/addresses/data/model/address_model.dart';

final addressRepository =
    Provider<AddressRepository>((ref) => AddressRepository(ref));

class AddressRepository {
  late Dio dio;
  final Ref _ref;

  AddressRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  void cleanCache() async {}

  Future<List<AddressModel>> fetchAddress() async {
    late dynamic response;
    final String url = await Config.baseURL;
    try {
      response =
          await dio.get('$url/enderecamentos/enderecos', queryParameters: {
        'page': "1",
        'pageSize': "10000",
      });

      if (response.statusCode != 200) {
        throw const Failure("Server Error!", ErrorType.exception);
      }

      if (response.data.isEmpty) {
        throw const Failure(
            "Nenhum registro encontrado.", ErrorType.validation);
      }

      final listAddress = (response.data['resultado'] as List).map((item) {
        return AddressModel.fromMap(item);
      }).toList();
      return listAddress;
/*       return listAddress
          .where((element) => element.local.contains(warehouse))
          .toList(); */
    } on DioError catch (e) {
      log(e.type.name);
      throw const Failure("Server Error!", ErrorType.exception);
    }
  }
}
