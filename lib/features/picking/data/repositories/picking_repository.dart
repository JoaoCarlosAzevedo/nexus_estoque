import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/constants/config.dart';
import 'package:nexus_estoque/core/constants/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';
import 'package:nexus_estoque/features/picking/data/model/picking_model.dart';
import 'package:nexus_estoque/features/picking/data/model/picking_order_model.dart';

final pickingRepositoryProvider =
    Provider<PickingRepository>((ref) => PickingRepository(ref));

class PickingRepository {
  late Dio dio;
  final String url = Config.baseURL!;
  final Ref _ref;
  final options = DioConfig.dioBaseOption;

  PickingRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<Either<Failure, List<PickingOrder>>> fetchPickingList() async {
    try {
      var response = await dio.get('$url/separacao/pedido/', queryParameters: {
        'empresa': "01",
        'filial': "01",
      });

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        return const Left(Failure("Nao Encontrado!", ErrorType.validation));
      }
      final listProducts = (response.data['resultado'] as List).map((item) {
        return PickingOrder.fromMap(item);
      }).toList();

      return Right(listProducts);
    } on DioError catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }

  Future<Either<Failure, String>> postPicking(PickingModel picking) async {
    try {
      var response = await dio.post('$url/separacao/pedido/',
          data: picking.toJson(),
          queryParameters: {
            'empresa': "01",
            'filial': "01",
          });

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
}
