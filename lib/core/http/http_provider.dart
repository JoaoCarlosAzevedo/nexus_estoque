import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/http/interceptor.dart';

final httpProvider = Provider<HttpProvider>(
  (ref) => HttpProvider(ref),
);

class HttpProvider {
  final Ref _ref;
  late Dio _dio;

  HttpProvider(this._ref) {
    _dio = Dio();
    _dio.options.sendTimeout = 30000;
    _dio.options.connectTimeout = 30000;
    _dio.options.receiveTimeout = 30000;
    _dio.interceptors.add(AppInterceptors(_dio, _ref));
  }

  Dio get dioInstance => _dio;
}
