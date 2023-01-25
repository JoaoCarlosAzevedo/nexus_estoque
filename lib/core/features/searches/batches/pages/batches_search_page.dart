import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/searches/batches/provider/remote_batches_provider.dart';

class BatchSearchPage extends ConsumerStatefulWidget {
  const BatchSearchPage({super.key});

  @override
  ConsumerState<BatchSearchPage> createState() => _BatchSearchPageState();
}

class _BatchSearchPageState extends ConsumerState<BatchSearchPage> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(remoteBatchProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Busca Lotes"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                ref.invalidate(remoteBatchProvider);
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: provider.when(
        skipLoadingOnRefresh: false,
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (data) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context, data[index].lote);
                        },
                        title: Text(data[index].lote),
                        subtitle: Text(data[index].lotefor),
                        trailing: Text(data[index].saldo.toString()),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
