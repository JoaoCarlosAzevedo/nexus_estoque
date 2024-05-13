import 'package:nexus_estoque/core/services/secure_store.dart';

class Config {
  static Future<String> get baseURL => LocalStorage.getURL();
}
