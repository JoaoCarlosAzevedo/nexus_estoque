import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/features/searches/batches/provider/remote_batches_provider.dart';

class BatchSearchPage extends ConsumerStatefulWidget {
  BatchSearchPage({required this.product, required this.warehouse, super.key}) {
    args = [product, warehouse];
  }
  final String product;
  final String warehouse;
  late final List<String> args;

  @override
  ConsumerState<BatchSearchPage> createState() => _BatchSearchPageState();
}

class _BatchSearchPageState extends ConsumerState<BatchSearchPage> {
  @override
  Widget build(BuildContext context) {
    final futureProvider = ref.watch(remoteBatchProvider(widget.args));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Busca Lotes"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                ref.invalidate(remoteBatchProvider(widget.args));
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
