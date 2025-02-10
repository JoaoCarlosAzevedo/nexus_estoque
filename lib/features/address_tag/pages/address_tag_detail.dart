import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/features/bluetooth_printer/bluetooth_printer.dart';
import '../../../core/services/bt_printer.dart';
import '../data/model/address_tag_model.dart';
import '../data/repositories/address_tag_repository.dart';

class AddressTagPreview extends ConsumerStatefulWidget {
  const AddressTagPreview({super.key, required this.barcode});
  final String barcode;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressTagPreviewState();
}

class _AddressTagPreviewState extends ConsumerState<AddressTagPreview> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(remoteAddressTagZplProvider(widget.barcode));
    final map = addressToMap(widget.barcode);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Etiqueta Endereço"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: provider.when(
          data: (data) => Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  if (map["armazem"] != null)
                    Text("Armazém ${map["armazem"]}",
                        style: Theme.of(context).textTheme.titleLarge),
                  const Divider(),
                  if (map["departamento"] != null)
                    Text("Departamento ${map["departamento"]}",
                        style: Theme.of(context).textTheme.titleLarge),
                  const Divider(),
                  if (map["rua"] != null)
                    Text("Rua ${map["rua"]}",
                        style: Theme.of(context).textTheme.titleLarge),
                  const Divider(),
                  if (map["predio"] != null)
                    Text("Prédio ${map["predio"]}",
                        style: Theme.of(context).textTheme.titleLarge),
                  const Divider(),
                  if (map["nivel"] != null)
                    Text("Nível ${map["nivel"]}",
                        style: Theme.of(context).textTheme.titleLarge),
                  const Divider(),
                  if (map["apartamento"] != null)
                    Text("Aparamento ${map["apartamento"]}",
                        style: Theme.of(context).textTheme.titleLarge),
                  const Divider(),
                  /*    Card(
                    child: Image.network(data.urlPreview),
                  ), */
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              label: const Text("Imprimir Etiqueta"),
              onPressed: () async {
                final isPrinted = await BluetoothPrinter.printZPL(data);
                if (!isPrinted) {
                  // ignore: use_build_context_synchronously
                  BluetoothPageModal.show(context);
                }
              },
              icon: const Icon(Icons.print),
              backgroundColor: Colors.green,
            ),
          ),
          error: (erro, stack) => Center(
            child: Text(erro.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
