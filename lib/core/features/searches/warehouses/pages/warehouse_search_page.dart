import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/features/searches/warehouses/data/model/warehouse_model.dart';
import 'package:nexus_estoque/core/features/searches/warehouses/providers/remote_warehouse_provider.dart';
import 'package:nexus_estoque/features/transaction/pages/transaction_form_page/widgets/transaction_form.dart';

class WarehouseSearchModal {
  static Future<String> show(
      context, ProductBalanceModel product, Tm tm) async {
    {
      final result = await showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.9,
            child: WarehouseSearchPage(product, tm),
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

class WarehouseSearchPage extends ConsumerStatefulWidget {
  const WarehouseSearchPage(this.product, this.tm,
      {super.key, this.productWarehouse = const []});

  final ProductBalanceModel product;
  final List<WarehouseModel> productWarehouse;
  final Tm tm;
  @override
  ConsumerState<WarehouseSearchPage> createState() =>
      _WarehouseSearchPageState();
}

class _WarehouseSearchPageState extends ConsumerState<WarehouseSearchPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<WarehouseModel>> futureProvider =
        ref.watch(remoteWarehouseProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Busca Armazem"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                ref.invalidate(remoteWarehouseProvider);
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: widget.tm == Tm.saida
          ? BalanceWarehouses(
              product: widget.product,
            )
          : futureProvider.when(
              skipLoadingOnRefresh: false,
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) {
                final Failure failure = err as Failure;
                return Center(child: Text(failure.error));
              },
              data: (data) {
                return AllWarehouses(
                  warehouses: data,
                );
              },
            ),
    );
  }
}

class AllWarehouses extends StatelessWidget {
  const AllWarehouses({
    super.key,
    required this.warehouses,
  });
  final List<WarehouseModel> warehouses;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: warehouses.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context, warehouses[index].codigo);
                    },
                    title: Text(warehouses[index].descricao),
                    subtitle: Text('Local: ${warehouses[index].codigo}'),
                    trailing: Text('Filial ${warehouses[index].filial}'),
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

class BalanceWarehouses extends StatelessWidget {
  const BalanceWarehouses({
    super.key,
    required this.product,
  });
  final ProductBalanceModel product;

  @override
  Widget build(BuildContext context) {
    final warehouses = product.armazem;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: product.armazem.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context, warehouses[index].codigo);
                    },
                    title: Text(warehouses[index].descricao),
                    subtitle: Text('Local: ${warehouses[index].codigo}'),
                    trailing: Text(
                        '${warehouses[index].saldoLocal.toString()} ${product.uM}'),
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
