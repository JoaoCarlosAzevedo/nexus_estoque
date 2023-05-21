import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';
import 'package:nexus_estoque/features/reposition/data/model/reposition_model.dart';

final repositionRepositoryProvider =
    Provider<RepositionRepository>((ref) => RepositionRepository(ref));

class RepositionRepository {
  late Dio dio;
  final Ref _ref;
  final options = DioConfig.dioBaseOption;

  RepositionRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<Either<Failure, List<RepositionModel>>> fetchReposition() async {
    final String url = await Config.baseURL;
    try {
      var response = await dio.get('$url/reposicao/');

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        return const Left(Failure("Nao Encontrado!", ErrorType.validation));
      }
      final listRoutes = (response.data as List).map((item) {
        return RepositionModel.fromMap(item);
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
