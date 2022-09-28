import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String? get baseURL =>
      dotenv.isInitialized ? dotenv.env['BASEURL'].toString() : '';
}
