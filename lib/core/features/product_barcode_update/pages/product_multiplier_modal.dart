import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/form_input_no_keyboard_widget.dart';
import '../../searches/products/data/model/product_model.dart';
import '../provider/product_barcode_update_notifier.dart';

Future<bool> showProductBarcodeUpdateModal(
    BuildContext context, ProductModel product) async {
  final response = await showDialog<bool>(
      context: context,
      builder: (_) => ProductBarcodeUpdateModal(
            product: product,
          ));
  if (response == null) {
    return false;
  }
  return response;
}

class ProductBarcodeUpdateModal extends ConsumerStatefulWidget {
  const ProductBarcodeUpdateModal({super.key, required this.product});

  final ProductModel product;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductBarcodeUpdateModalState();
}

class _ProductBarcodeUpdateModalState
    extends ConsumerState<ProductBarcodeUpdateModal> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller.text = widget.product.codigoBarras;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider2 = ref.watch(productBarcodeUpdateChangeProvider);

    ref.listen(productBarcodeUpdateChangeProvider, (previous, current) {
      if (current is AsyncData) {
        if (current.value ?? false) {
          Navigator.pop(context, true);
        }
      }

      if (current is AsyncError) {
        AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                desc: current.error.toString(),
                btnOkOnPress: () {},
                btnOkColor: Theme.of(context).primaryColor)
            .show();
      }
    });

    return AlertDialog(
      content: SizedBox(
        width: 200,
        height: 200,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              widget.product.descricao,
              overflow: TextOverflow.ellipsis,
            ),
            const Divider(),
            const Divider(),

            /*    TextField(
              autofocus: true,
              style: const TextStyle(fontSize: 20), 
              textAlign: TextAlign.center,
              controller: controller,
            ), */
            NoKeyboardTextForm(
              label: 'Novo Cód. de Barras',
              controller: controller,
              autoFocus: true,
            ),
            const Divider(),
            provider2.when(
              data: (data) => ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    ref
                        .read(productBarcodeUpdateChangeProvider.notifier)
                        .postBarcode(widget.product.codigo, controller.text);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Confirmar"),
                ),
              ),
              error: (_, __) => ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    ref
                        .read(productBarcodeUpdateChangeProvider.notifier)
                        .postBarcode(widget.product.codigo, controller.text);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Confirmar"),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            )
          ],
        ),
      ),
    );
  }
}
