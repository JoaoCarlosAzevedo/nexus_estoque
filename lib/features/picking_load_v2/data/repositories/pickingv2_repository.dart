import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';

import '../model/pickingv2_model.dart';
import '../model/shippingv2_model.dart';

final pickingv2RepositoryProvider =
    Provider<Pickingv2Repository>((ref) => Pickingv2Repository(ref));

class Pickingv2Repository {
  late Dio dio;
  final Ref _ref;
  final options = DioConfig.dioBaseOption;

  Pickingv2Repository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<Either<Failure, String>> postPicking(Pickingv2Model picking) async {
    final String url = await Config.baseURL;
    final List<Pickingv2Model> pickingList = [picking];
    final jsonList = pickingList
        .map((e) => {
              'separado': e.separado,
              'recnoSDC': e.recnoSDC,
            })
        .toList();

    final String json = jsonEncode(jsonList);

    try {
      var response = await dio.post(
        '$url/separacao/v2/',
        data: json,
      );

      if (response.statusCode != 201) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        return const Left(Failure("Nao Encontrado!", ErrorType.validation));
      }

      return const Right("Created");
    } on DioException catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }

      if (e.response!.data["message"] != "") {
        return Left(Failure(e.response!.data["message"], ErrorType.validation));
      }

      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }

  Future<Either<Failure, List<Shippingv2Model>>> fetchPickingLoadList() async {
    final String url = await Config.baseURL;
    try {
      var response = await dio.get('$url/separacao/rota/', queryParameters: {
        //'tipo': " DAK_DATA = '20240527' ",
        'tipo': " DAK_COD IN ('095263','095224') ",
      });

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        return const Left(Failure("Nao Encontrado!", ErrorType.validation));
      }
      final listRoutes = (response.data as List).map((item) {
        return Shippingv2Model.fromMap(item);
      }).toList();

      return Right(listRoutes);
    } on DioException catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }
}
