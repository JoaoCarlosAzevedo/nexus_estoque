import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/features/searches/batches/data/model/batch_model.dart';
import 'package:nexus_estoque/core/features/searches/batches/data/model/product_arg_model.dart';
import 'package:nexus_estoque/core/features/searches/batches/provider/remote_batches_provider.dart';
import 'package:nexus_estoque/features/transaction/pages/transaction_form_page/widgets/transaction_form.dart';

class BatchSearchModal {
  static Future<String> show(
      context, ProductBalanceModel product, String warehouse, Tm tm) async {
    {
      final result = await showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.9,
            child: BatchSearchPage(
              product: product,
              productArgs:
                  ProductArg(product: product.codigo, warehouse: warehouse),
              tm: tm,
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

class BatchSearchPage extends ConsumerWidget {
  const BatchSearchPage(
      {required this.product,
      required this.productArgs,
      required this.tm,
      super.key});
  final ProductBalanceModel product;
  final ProductArg productArgs;
  final Tm tm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //if tm == Tm.entrada ? RemoteBatch(product):
    final balanceBatches = product.armazem.firstWhere(
      (element) => element.codigo == productArgs.warehouse,
    );
    final batches = balanceBatches.lotes;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Busca Lotes"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  ref.invalidate(remoteBatchProvider(productArgs));
                },
                icon: const Icon(Icons.refresh)),
          ],
        ),
        body: tm == Tm.entrada
            ? RemoteBatch(productArgs)
            : BatchList(
                batches: batches,
              ));
  }
}

class RemoteBatch extends ConsumerWidget {
  const RemoteBatch(this.product, {super.key});
  final ProductArg product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureProvider = ref.watch(remoteBatchProvider(product));
    return futureProvider.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          final Failure failure = err as Failure;
          return Center(child: Text(failure.error));
        },
        data: (data) {
          return BatchList(batches: data);
        });
  }
}

class BatchList extends ConsumerStatefulWidget {
  const BatchList({required this.batches, super.key});
  final List<BatchModel> batches;

  @override
  ConsumerState<BatchList> createState() => _BatchListState();
}

class _BatchListState extends ConsumerState<BatchList> {
  List<BatchModel> listBatches = [];
  bool resetFilter = true;

  @override
  Widget build(BuildContext context) {
    if (resetFilter) {
      listBatches = widget.batches;
      resetFilter = false;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            onChanged: (e) {
              searchBatch(e, widget.batches);
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
