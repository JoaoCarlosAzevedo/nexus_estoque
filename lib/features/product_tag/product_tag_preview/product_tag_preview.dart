import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/features/bluetooth_printer/bluetooth_printer.dart';
import '../../../core/services/bt_printer.dart';
import '../data/repositories/product_tag_repository.dart';

class ProductTagPreview extends ConsumerStatefulWidget {
  const ProductTagPreview({super.key, required this.barcode});
  final String barcode;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductTagPreviewState();
}

class _ProductTagPreviewState extends ConsumerState<ProductTagPreview> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(remoteProductTagProvider(widget.barcode));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Etiqueta Produto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: provider.when(
          data: (data) => Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Text("SKU: ${widget.barcode}"),
                  const Divider(),
                  Card(
                    child: Image.network(data.urlPreview),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              label: const Text("Imprimir Etiqueta"),
              onPressed: () async {
                final isPrinted = await BluetoothPrinter.printZPL(data.zpl);
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
