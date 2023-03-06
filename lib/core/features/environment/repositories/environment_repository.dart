// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final environmentRepository =
    Provider<EnvironmentRepository>((ref) => EnvironmentRepository(ref));

class EnvironmentRepository {
  final Ref _ref;
  final dio = Dio();

  EnvironmentRepository(this._ref);

  Future<bool> urlTest(String url) async {
    Response response;
    try {
      response = await dio.get('$url/healthcheck');
      if (response.statusCode == 200) {
        return true;
      }
    } on DioError catch (_) {
      return false;
    }

    return false;
  }
}
