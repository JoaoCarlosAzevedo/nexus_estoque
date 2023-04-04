import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/dio_config.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';
import 'package:nexus_estoque/features/outflow_doc_check/data/model/outflow_doc_model.dart';

final outflowDocRepository =
    Provider<OutflowDocRepository>((ref) => OutflowDocRepository(ref));

class OutflowDocRepository {
  late Dio dio;
  final Ref _ref;
  final options = DioConfig.dioBaseOption;

  OutflowDocRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<Either<Failure, List<OutFlowDoc>>> fetchOutflowDoc() async {
    final String url = await Config.baseURL;
    try {
      var response =
          await dio.get('$url/conferencia_nf_saida', queryParameters: {
        /*   'page': "1",
        'pageSize': "10000", */
      });

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        return const Left(Failure("Nao Encontrado!", ErrorType.validation));
      }
      final listDocs = (response.data['resultado'] as List).map((item) {
        return OutFlowDoc.fromMap(item);
      }).toList();

      return Right(listDocs);
    } on DioError catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }
}
