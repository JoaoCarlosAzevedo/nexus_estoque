import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/constants/secure_store.dart';

final localEnvironmentRepository = Provider<LocalEnvironmentRepository>(
    (ref) => LocalEnvironmentRepository(ref));

class LocalEnvironmentRepository {
  final Ref _ref;

  LocalEnvironmentRepository(this._ref);

  Future<String> getURL() async {
    final localStorage = _ref.watch(urlStoreProvider);
    return await localStorage.getURL();
  }
}
