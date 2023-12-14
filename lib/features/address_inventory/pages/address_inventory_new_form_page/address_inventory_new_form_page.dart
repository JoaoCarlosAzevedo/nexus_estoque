import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../address_balance/data/model/address_balance_model.dart';
import '../../data/model/inventory_model.dart';
import '../../data/repositories/inventory_repository.dart';
import '../address_inventory_form_page/address_inventory_form_page.dart';
import '../address_inventory_form_page/widgets/address_warehouse_card.dart';
import '../address_inventory_list/widgets/delete_icon_widget.dart';

class InventoryAddressNewFormPage extends ConsumerStatefulWidget {
  const InventoryAddressNewFormPage(
      {required this.address, required this.doc, super.key});

  final AddressBalanceModel address;
  final String doc;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InventoryAddressNewFormPageState();
}

class _InventoryAddressNewFormPageState
    extends ConsumerState<InventoryAddressNewFormPage> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<List<InventoryModel>> inventory = ref.watch(
        remoteGetInventoryProvider(
            '${widget.address.codEndereco}|${widget.doc}'));

    return inventory.when(
      skipLoadingOnRefresh: false,
      loading: () => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Contagem Produtos"),
            actions: [
              IconButton(
                  onPressed: () {
                    ref.invalidate(remoteGetInventoryProvider(
                        '${widget.address.codEndereco}|${widget.doc}'));
                  },
                  icon: const Icon(Icons.refresh)),
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (error, stackTrace) => Center(
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Contagem Produtos"),
              actions: [
                IconButton(
                    onPressed: () {
                      ref.invalidate(remoteGetInventoryProvider(
                          '${widget.address.codEndereco}|${widget.doc}'));
                    },
                    icon: const Icon(Icons.refresh)),
              ],
            ),
            resizeToAvoidBottomInset: false,
            body: Center(
              child: Text(stackTrace.toString()),
            ),
          ),
        ),
      ),
      data: (List<InventoryModel> data) {
        if (data.isEmpty) {
          return AddressInventoryFormPage(
            address: widget.address,
            doc: widget.doc,
          );
        }
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Contagem Produtos"),
              actions: [
                IconButton(
                  onPressed: () {
                    ref.invalidate(remoteGetInventoryProvider(
                        '${widget.address.codEndereco}|${widget.doc}'));
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Documento: ${widget.doc}",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  AddressWarehouseCard(
                    address: widget.address,
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
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
