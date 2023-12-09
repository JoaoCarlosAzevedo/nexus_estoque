import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/inventory_model.dart';
import '../../data/repositories/inventory_repository.dart';
import 'widgets/delete_icon_widget.dart';

class AddressInventoryListPage extends ConsumerWidget {
  const AddressInventoryListPage(
      {required this.address, required this.warehouse, super.key});
  final String address;
  final String warehouse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<InventoryModel>> inventory =
        ref.watch(remoteGetInventoryProvider(address));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta Inventário"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: inventory.when(
            data: (snapshot) {
              if (snapshot.isEmpty) {
                return const Center(child: Text("Nenhum registro encontrado."));
              }

              final data = snapshot
                  .where((element) => element.local.contains(warehouse))
                  .toList();

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(data[index].descPro),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Doc.: ${data[index].doc}"),
                          Text(data[index].codEndereco),
                          Text("Local: ${data[index].local}"),
                        ],
                      ),
                      trailing:
                          Text('${data[index].quantInvent} ${data[index].uM}'),
                      leading: InventoryDeleteIcon(
                        recno: data[index].recno,
                      ),
                    ),
                  );
                },
              );
            },
            error: (obj, error) => Center(
                  child: Text("Error ${error.toString()}"),
                ),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )),
      ),
    );
  }
}
