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

class ListClients extends StatefulWidget {
  const ListClients({
    Key? key,
    required this.clients,
  }) : super(key: key);
  final List<ClientModel> clients;

  @override
  State<ListClients> createState() => _ListClientsState();
}

class _ListClientsState extends State<ListClients> {
  List<ClientModel> filterClients = [];
  bool resetFilter = true;

  @override
  Widget build(BuildContext context) {
    if (resetFilter) {
      filterClients = widget.clients;
      resetFilter = false;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            onChanged: (e) {
              clientSearch(e);
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              label: Text("Pesquisar"),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filterClients.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context, filterClients[index]);
                    },
                    title: Text(filterClients[index].nome),
                    subtitle: Text(
                        '${filterClients[index].codigo}  ${filterClients[index].loja}'),
                    trailing: Text('Filial ${filterClients[index].filial}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void clientSearch(String value) {
    if (value.isNotEmpty) {
      setState(() {
        filterClients = widget.clients.where((element) {
          if (element.codigo.toUpperCase().contains(value.toUpperCase())) {
            return true;
          }

          if (element.nome.toUpperCase().contains(value.toUpperCase())) {
            return true;
          }
          return false;
        }).toList();
      });
    } else {
      setState(() {
        resetFilter = true;
      });
    }
  }
}
