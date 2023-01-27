import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/features/searches/warehouses/data/model/warehouse_model.dart';
import 'package:nexus_estoque/core/features/searches/warehouses/providers/remote_warehouse_provider.dart';

class WarehouseSearchPage extends ConsumerStatefulWidget {
  const WarehouseSearchPage({super.key, this.productWarehouse = const []});

  final List<WarehouseModel> productWarehouse;

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
              IconButton(
                  onPressed: () {
                    ref.invalidate(remoteWarehouseProvider);
                  },
                  icon: const Icon(Icons.abc)),
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context, data[index].codigo);
                        },
                        title: Text(data[index].descricao),
                        subtitle: Text(data[index].codigo),
                        trailing: Text(data[index].filial),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
/*       body: widget.productWarehouse.isEmpty
          ? NetworkWarehouse(ref: ref)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.productWarehouse.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.pop(
                                context, widget.productWarehouse[index].codigo);
                          },
                          title: Text(widget.productWarehouse[index].descricao),
                          subtitle: Text(widget.productWarehouse[index].codigo),
                          trailing: Text(widget.productWarehouse[index].filial),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ), */
    );
  }
}
