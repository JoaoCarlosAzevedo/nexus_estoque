import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';
import 'package:nexus_estoque/features/picking/data/model/picking_model.dart';
import 'package:nexus_estoque/features/picking_route/data/model/picking_route_model.dart';

import '../model/shipping_model.dart';

final pickingRouteRepositoryProvider =
    Provider<PickingRouteRepository>((ref) => PickingRouteRepository(ref));

class PickingRouteRepository {
  late Dio dio;
  final Ref _ref;
  final options = DioConfig.dioBaseOption;

  PickingRouteRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<Either<Failure, List<PickingRouteModel>>> fetchPickingList() async {
    final String url = await Config.baseURL;
    try {
      var response = await dio.get('$url/separacao/rota/');

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        return const Left(Failure("Nao Encontrado!", ErrorType.validation));
      }
      final listRoutes = (response.data as List).map((item) {
        return PickingRouteModel.fromMap(item);
      }).toList();

      return Right(listRoutes);
    } on DioError catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }

  Future<Either<Failure, String>> postPicking(PickingModel picking) async {
    final String url = await Config.baseURL;
    try {
      var response = await dio.post(
        '$url/separacao/pedido/',
        data: picking.toJson(),
      );

      if (response.statusCode != 201) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        return const Left(Failure("Nao Encontrado!", ErrorType.validation));
      }

      return const Right("Created");
    } on DioError catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }

      if (e.response!.data["message"] != "") {
        return Left(Failure(e.response!.data["message"], ErrorType.validation));
      }

      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }

  Future<Either<Failure, List<ShippingModel>>> fetchPickingLoadList() async {
    final String url = await Config.baseURL;
    try {
      var response = await dio.get('$url/separacao/rota/', queryParameters: {
        'tipo': 'carga',
      });

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        return const Left(Failure("Nao Encontrado!", ErrorType.validation));
      }
      final listRoutes = (response.data as List).map((item) {
        return ShippingModel.fromMapv2(item);
      }).toList();

      return Right(listRoutes);
    } on DioError catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }
}
