import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/utils/secure_store.dart';

final localEnvironmentRepository = Provider<LocalEnvironmentRepository>(
    (ref) => LocalEnvironmentRepository(ref));

class LocalEnvironmentRepository {
  final Ref _ref;

  LocalEnvironmentRepository(this._ref);

  Future<String> getURL() async {
    return LocalStorage.getURL();
  }
}
