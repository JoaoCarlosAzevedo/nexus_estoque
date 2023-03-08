import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/environment/repositories/remote_environment_repository.dart';

final remoteEnvrionmentProvider =
    FutureProvider.family.autoDispose<String, String>((ref, args) async {
  if (args.isEmpty) {
    return '';
  }
  final result = await ref.read(remoteEnvironmentRepository).urlTest(args);
  return result;
});
