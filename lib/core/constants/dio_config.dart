import 'package:dio/dio.dart';

import 'config.dart';

class DioConfig {
  static BaseOptions get dioBaseOption => BaseOptions(
        baseUrl: Config.baseURL!,
        connectTimeout: 10000,
        receiveTimeout: 10000,
      );
}
