import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/constants/config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';
import 'package:nexus_estoque/core/features/searches/addresses/data/model/address_model.dart';

final addressRepository =
    Provider<AddressRepository>((ref) => AddressRepository(ref));

class AddressRepository {
  late Dio dio;
  final String url = Config.baseURL!;
  final Ref _ref;

  AddressRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  void cleanCache() async {}

  Future<List<AddressModel>> fetchAddress() async {
    late dynamic response;
    try {
      response =
          await dio.get('$url/enderecamentos/enderecos', queryParameters: {
        'empresa': "01",
        'filial': "01",
        'page': "1",
        'pageSize': "10000",
      });

      if (response.statusCode != 200) {
        throw const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        throw const Left(
            Failure("Nenhum registro encontrado.", ErrorType.validation));
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
      throw const Left(Failure("Server Error!", ErrorType.exception));
    }
  }
}
