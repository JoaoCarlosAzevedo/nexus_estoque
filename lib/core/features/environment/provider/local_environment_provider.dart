import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/environment/repositories/local_environment_repository.dart';

final localEnvrionmentProvider = FutureProvider<String>((ref) async {
  final result = await ref.read(localEnvironmentRepository).getURL();
  return result;
});
