import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nexus_estoque/core/features/branches/data/model/branch_model.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/services/secure_store.dart';
import 'package:nexus_estoque/features/auth/providers/login_controller_provider.dart';

class AppInterceptors extends Interceptor {
  final _storage = const FlutterSecureStorage();
  final Dio _dio;
  final Ref _ref;
  String? accessToken;

  AppInterceptors(this._dio, this._ref);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    log('REQUEST[${options.method}] => PATH: ${options.path}');

    //se for uma nova solicitacao de autenticacao, deleta os tokens anteriores
    if (options.path.contains('oauth2/v1/token')) {
      await _storage.delete(key: 'refresh_token');
    }

    accessToken ??= await _storage.read(key: 'access_token');

    if (!options.path.contains('oauth2/v1/token')) {
      final Branch? env = await LocalStorage.getBranch();

      options.headers['Authorization'] = 'Bearer $accessToken';
      options.queryParameters['empresa'] = env?.groupCode.trim() ?? "";
      options.queryParameters['filial'] = env?.branchCode.trim() ?? "";

      log('REQUEST[${options.method}] => PARAMETERS: ${options.queryParameters.toString()}');
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    log('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');

    if (err.response?.statusCode == 401) {
      if (await _storage.containsKey(key: 'refresh_token')) {
        await refreshToken();
        return handler.resolve(await _retry(err.requestOptions));
      }
      /* 
      else {
        //await getToken();
        return handler.resolve(await _retry(err.requestOptions));
      } */
    }

    return super.onError(err, handler);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options =
        Options(method: requestOptions.method, headers: requestOptions.headers);

    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<void> refreshToken() async {
    final refreshToken = await _storage.read(key: 'refresh_token');
    final dio = Dio();
    final String baseUrl = await Config.baseURL;
    try {
      final response =
          await dio.post('$baseUrl/api/oauth2/v1/token', queryParameters: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      });
      log("REFRESH_TOKEN[POST]");
      //se atualizou o refreshtoken na api
      if (response.statusCode == 201) {
        accessToken = response.data["access_token"]; //talvez pasear aqui
        final newRefreshToken =
            response.data["refresh_token"]; //talvez pasear aqui
        await _storage.write(key: 'refresh_token', value: newRefreshToken);
      } else {
        accessToken = null;
        await _storage.delete(key: 'refresh_token');
        _ref.read(loginControllerProvider.notifier).logout();
      }
    } on DioError catch (_) {
      //se o refreshtoken n deu certo, forca relogar;
      accessToken = null;
      await _storage.delete(key: 'refresh_token');
      _ref.read(loginControllerProvider.notifier).logout();
    }
/* 
    //refresh token eh invalido e nao funcionou
    accessToken = null;
    _storage.deleteAll(); */
  }
}
