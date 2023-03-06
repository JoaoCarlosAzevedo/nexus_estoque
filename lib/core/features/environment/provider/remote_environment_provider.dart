import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/environment/repositories/environment_repository.dart';

final remoteEnvrionmentProvider =
    FutureProvider.family.autoDispose<bool, String>((ref, args) async {
  if (args.isEmpty) {
    return false;
  }
  final result = await ref.read(environmentRepository).urlTest(args);
  return result;
});
