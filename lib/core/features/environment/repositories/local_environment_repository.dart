import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/utils/secure_store.dart';

final localEnvironmentRepository =
    Provider<LocalEnvironmentRepository>((ref) => LocalEnvironmentRepository());

class LocalEnvironmentRepository {
  LocalEnvironmentRepository();

  Future<String> getURL() async {
    return LocalStorage.getURL();
  }
}
