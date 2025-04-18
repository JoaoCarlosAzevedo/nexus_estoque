import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../address_inventory/data/model/inventory_model.dart';
import '../../address_inventory/data/repositories/inventory_repository.dart';
import '../../address_inventory/pages/address_inventory_list/widgets/delete_icon_widget.dart';

class ProductInventoryListPage extends ConsumerWidget {
  const ProductInventoryListPage(
      {required this.doc, required this.product, super.key});
  final String doc;
  final String product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<InventoryModel>> inventory =
        ref.watch(remoteGetProductInventoryProvider("data|$product|$doc"));

    ref.listen(
      remoteGetProductInventoryProvider("data|$product|$doc"),
      (AsyncValue<List<InventoryModel>>? _,
          AsyncValue<List<InventoryModel>> next) {
        if (next.hasValue) {
          if (next.asData!.value.isEmpty) {
            //context.push("/inventario_endereco/form/aaaa", extra: addressModel);
          }
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta Inventário"),
        actions: [
          IconButton(
              onPressed: () {
                ref.invalidate(remoteGetProductInventoryProvider);
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: inventory.when(
            skipLoadingOnRefresh: false,
            data: (snapshot) {
              if (snapshot.isEmpty) {
                return const Center(child: Text("Nenhum registro encontrado."));
              }

              final data = snapshot;
              final total =
                  data.fold(0.0, (acc, element) => acc + element.quantInvent);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Total Geral: $total"),
                  ),
                  Expanded(
                    child: ListView.builder(
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
                            trailing: Text(
                                '${data[index].quantInvent} ${data[index].uM}'),
                            leading: InventoryDeleteIcon(
                              recno: data[index].recno,
                              onSuccess: () {},
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
