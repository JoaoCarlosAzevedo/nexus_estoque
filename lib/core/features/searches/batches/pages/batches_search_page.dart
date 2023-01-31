import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/features/searches/batches/data/model/batch_model.dart';
import 'package:nexus_estoque/core/features/searches/batches/data/model/product_arg_model.dart';
import 'package:nexus_estoque/core/features/searches/batches/provider/remote_batches_provider.dart';

class BatchSearchModal {
  static Future<String> show(context, String product, String warehouse) async {
    {
      final result = await showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.9,
            child: BatchSearchPage(
              product: ProductArg(product: product, warehouse: warehouse),
            ),
          );
        },
      );

      if (result != null) {
        return result;
      } else {
        return '';
      }
    }
  }
}

class BatchSearchPage extends ConsumerStatefulWidget {
  const BatchSearchPage({required this.product, super.key});
  final ProductArg product;

  @override
  ConsumerState<BatchSearchPage> createState() => _BatchSearchPageState();
}

class _BatchSearchPageState extends ConsumerState<BatchSearchPage> {
  List<BatchModel> listBatches = [];
  bool resetFilter = true;

  @override
  Widget build(BuildContext context) {
    final futureProvider = ref.watch(remoteBatchProvider(widget.product));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Busca Lotes"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                ref.invalidate(remoteBatchProvider(widget.product));
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
          if (resetFilter) {
            listBatches = data;
            resetFilter = false;
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (e) {
                    searchBatch(e, data);
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    label: Text("Pesquisar"),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: listBatches.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.pop(context, listBatches[index].lote);
                          },
                          title: Text(listBatches[index].lote),
                          subtitle: Text(listBatches[index].lotefor),
                          trailing: Text(listBatches[index].saldo.toString()),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void searchBatch(String value, List<BatchModel> data) {
    if (value.isNotEmpty) {
      setState(() {
        listBatches = data.where((element) {
          if (element.lote.toUpperCase().contains(value.toUpperCase())) {
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
