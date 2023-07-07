import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/searches/clients/data/model/client_model.dart';
import 'package:nexus_estoque/core/features/searches/clients/data/repositories/client_repository.dart';

final remoteClientProvider = FutureProvider<List<ClientModel>>((ref) async {
  final repository = ref.read(clientRepository);
  final result = await repository.fetchClients();
  return result;
});
