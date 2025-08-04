import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/features/bluetooth_printer/bluetooth_printer.dart';
import '../../../../../core/services/bt_printer.dart';

class VolumeLabelPreview extends ConsumerStatefulWidget {
  const VolumeLabelPreview({super.key, required this.zpl});
  final String zpl;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VolumeLabelPreviewState();
}

class _VolumeLabelPreviewState extends ConsumerState<VolumeLabelPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Etiqueta Produto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("Dimensao Etiqueta"),
              const Divider(),
              Card(
                child: Image.network(widget.zpl),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Imprimir Etiqueta"),
        onPressed: () async {
          final isPrinted = await BluetoothPrinter.printZPL(widget.zpl);
          if (!isPrinted) {
            // ignore: use_build_context_synchronously
            BluetoothPageModal.show(context);
          }
        },
        icon: const Icon(Icons.print),
        backgroundColor: Colors.green,
      ),
    );
  }
}
