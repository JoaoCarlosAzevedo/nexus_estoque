import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/features/searches/clients/data/model/client_model.dart';
import 'package:nexus_estoque/core/features/searches/clients/providers/remote_client_provider.dart';

class ClientSearchModal {
  static Future<ClientModel?> show(context) async {
    {
      final result = await showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return const FractionallySizedBox(
            heightFactor: 0.9,
            child: ClientSearchPage(),
          );
        },
      );

      return result;
    }
  }
}

class ClientSearchPage extends ConsumerStatefulWidget {
  const ClientSearchPage({super.key});

  @override
  ConsumerState<ClientSearchPage> createState() => _ClientSearchPageState();
}

class _ClientSearchPageState extends ConsumerState<ClientSearchPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<ClientModel>> futureProvider =
        ref.watch(remoteClientProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Busca Cliente"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                ref.invalidate(remoteClientProvider);
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: futureProvider.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          final Failure failure = err as Failure;
          return Center(child: Text(failure.error));
        },
        data: (data) {
          return ListClients(
            clients: data,
          );
        },
      ),
    );
  }
}

class ListClients extends StatelessWidget {
  const ListClients({
    Key? key,
    required this.clients,
  }) : super(key: key);
  final List<ClientModel> clients;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: clients.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context, clients[index]);
                    },
                    title: Text(clients[index].nome),
                    subtitle: Text(
                        '${clients[index].codigo}  ${clients[index].loja}'),
                    trailing: Text('Filial ${clients[index].filial}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
