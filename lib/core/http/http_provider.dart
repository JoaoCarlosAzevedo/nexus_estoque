import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/constants/config.dart';
import 'package:nexus_estoque/core/http/interceptor.dart';

final httpProvider = Provider<HttpProvider>(
  (ref) => HttpProvider(ref),
);

class HttpProvider {
  final Ref _ref;
  late Dio _dio;
  late String _baseURL;

  HttpProvider(this._ref) {
    _dio = Dio();
    _dio.options.sendTimeout = 30000;
    _dio.options.connectTimeout = 30000;
    _dio.options.receiveTimeout = 30000;
    _dio.interceptors.add(AppInterceptors());
    _baseURL = Config.baseURL!;
  }

  Future<Response<dynamic>> post(
    String path,
    dynamic body, {
    String? newBaseUrl,
    String? token,
    Map<String, String?>? query,
  }) async {
    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
    };
    final response = await _dio.post(
      _baseURL + path,
      data: body,
      queryParameters: query,
      options: Options(validateStatus: (status) => true, headers: headers),
    );
    return response;
  }
}
