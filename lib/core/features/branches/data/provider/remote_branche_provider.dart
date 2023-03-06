import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/branches/data/model/branch_model.dart';
import 'package:nexus_estoque/core/features/branches/data/repositories/branch_repository.dart';

final remoteBranchProvider = FutureProvider<List<Branch>>((ref) async {
  final result = await ref.read(branchRepository).fetchBranches();
  return result;
});
