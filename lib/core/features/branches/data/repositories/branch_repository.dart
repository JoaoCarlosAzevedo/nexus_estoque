import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/features/branches/data/model/branch_model.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';

final branchRepository =
    Provider<BranchRepository>((ref) => BranchRepository(ref));

class BranchRepository {
  final Ref _ref;
  late Dio dio;

  BranchRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<List<Branch>> fetchBranches() async {
    final String url = await Config.baseURL;
    late dynamic response;
    try {
      response = await dio.get(
        '$url/filial/list',
      );

      if (response.statusCode != 200) {
        throw const Failure("Server Error!", ErrorType.exception);
      }

      if (response.data.isEmpty) {
        throw const Failure(
            "Nenhum registro encontrado.", ErrorType.validation);
      }

      final listAddress = (response.data['filiais'] as List).map((item) {
        return Branch.fromMap(item);
      }).toList();
      return listAddress;
    } on DioError catch (e) {
      log(e.message);
      throw const Failure("Server Error!", ErrorType.exception);
    }
  }
}
