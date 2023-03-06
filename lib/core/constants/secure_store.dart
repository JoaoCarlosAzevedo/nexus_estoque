import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final urlStoreProvider = Provider<UrlStore>((ref) => UrlStore());

class UrlStore {
  final _storage = const FlutterSecureStorage();

  void saveURL(String url) async {
    await _storage.write(key: 'url', value: url.trim());
  }

  Future<String> getURL() async {
    final url = await _storage.read(key: 'url');
    return url ?? '';
  }
}
