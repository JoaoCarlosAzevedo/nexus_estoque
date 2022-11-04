import 'package:dio/dio.dart';

import 'config.dart';

class DioConfig {
  static BaseOptions get dioBaseOption => BaseOptions(
        baseUrl: Config.baseURL!,
        connectTimeout: 20000,
        receiveTimeout: 20000,
      );
}
