import 'package:flutter/material.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/input_quantity.dart';

import '../../../../../core/features/searches/products/data/model/product_model.dart';

class InventoryQuantityModal {
  static Future<double?> show(
      context, ProductModel produto, double quantity) async {
    {
      final result = await showModalBottomSheet<double>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return InventoryQuantity(
            produto: produto,
            quantity: quantity,
          );
        },
      );
      return result;
    }
  }
}

class InventoryQuantity extends StatefulWidget {
  const InventoryQuantity(
      {super.key, required this.produto, required this.quantity});
  final ProductModel produto;
  final double quantity;

  @override
  State<InventoryQuantity> createState() => _InventoryQuantityState();
}

class _InventoryQuantityState extends State<InventoryQuantity> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.quantity.toString();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(16),
          //height: MediaQuery.of(context).size.height / 2,
          child: Column(
            children: [
              Text("${widget.produto.codigo} - ${widget.produto.descricao}",
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis),
              const Divider(),
              Text("Qtd: ${widget.produto.qtdInvet}",
                  style: Theme.of(context).textTheme.displayMedium,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(
                height: 10,
              ),
              InputQuantity(
                controller: controller,
                onSubmitted: (e) {
                  final double? quantity = double.tryParse(controller.text);
                  if (quantity != null) {
                    Navigator.of(context).pop(quantity);
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  final double? quantity = double.tryParse(controller.text);
                  if (quantity != null) {
                    Navigator.of(context).pop(quantity);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text("Confirmar"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
