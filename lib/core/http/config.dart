import 'package:nexus_estoque/core/services/secure_store.dart';

class Config {
/*   static String? get baseURL =>
      dotenv.isInitialized ? dotenv.env['BASEURL'].toString() : ''; */
  static Future<String> get baseURL => LocalStorage.getURL();
}
