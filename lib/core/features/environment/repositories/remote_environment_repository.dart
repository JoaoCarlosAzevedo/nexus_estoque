// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/services/secure_store.dart';
import 'package:nexus_estoque/core/features/environment/provider/url_provider.dart';

final remoteEnvironmentRepository = Provider<RemoteEnvironmentRepository>(
    (ref) => RemoteEnvironmentRepository(ref));

class RemoteEnvironmentRepository {
  final Ref _ref;
  final dio = Dio();

  RemoteEnvironmentRepository(this._ref);

  Future<String> urlTest(String url) async {
    Response response;
    try {
      response = await dio.get('$url/healthcheck');
      if (response.statusCode == 200) {
        await LocalStorage.saveURL(url.trim());
        _ref.read(urlProvider.notifier).state = url;
        return url;
      }
    } on DioError catch (_) {
      _ref.read(urlProvider.notifier).state = '';
      return '';
    }
    _ref.read(urlProvider.notifier).state = '';
    return '';
  }
}
