import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/constants/config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';
import 'package:nexus_estoque/core/pages/searches/address/data/model/address_model.dart';

final addressSearchRepository =
    Provider<AddressSearchRepository>((ref) => AddressSearchRepository(ref));

class AddressSearchRepository {
  late Dio dio;
  final String url = Config.baseURL!;
  final Ref _ref;

  AddressSearchRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<Either<Failure, List<AddressModel>>> fetchAddress(
      String warehouse) async {
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
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        return const Left(
            Failure("Nenhum registro encontrado.", ErrorType.validation));
      }

      final listAddress = (response.data['resultado'] as List).map((item) {
        return AddressModel.fromMap(item);
      }).toList();

      return Right(listAddress
          .where((element) => element.codigoEndereco.contains(warehouse))
          .toList());
    } on DioError catch (e) {
      log(e.type.name);
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }
}
