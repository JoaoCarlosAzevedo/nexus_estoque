import 'package:dio/dio.dart';

class DioConfig {
  static BaseOptions get dioBaseOption => BaseOptions(
        //baseUrl: Config.baseURL!,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
      );
}
