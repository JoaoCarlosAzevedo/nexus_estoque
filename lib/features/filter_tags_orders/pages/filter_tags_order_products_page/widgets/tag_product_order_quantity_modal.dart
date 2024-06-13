import 'package:flutter/material.dart';

import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/input_quantity.dart';

import '../../../data/model/filter_tag_load_order_model.dart';

class PurchaseFilterTagProductOrderQuantityModal {
  static Future<double?> show(
      context, OrdersProduct produto, double checked) async {
    {
      final result = await showModalBottomSheet<double>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FilterTagProductQuantity(
            produto: produto,
            checked: checked,
          );
        },
      );
      return result;
    }
  }
}

class FilterTagProductQuantity extends StatefulWidget {
  const FilterTagProductQuantity(
      {super.key, required this.produto, required this.checked});
  final OrdersProduct produto;
  final double checked;

  @override
  State<FilterTagProductQuantity> createState() =>
      _FilterTagProductQuantityState();
}

class _FilterTagProductQuantityState extends State<FilterTagProductQuantity> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.checked.toString();
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
              Text("${widget.produto.item} - ${widget.produto.descricao}",
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis),
              const Divider(),
              Text("Embalado: ${widget.produto.novaQuantidade}",
                  style: Theme.of(context).textTheme.displayMedium,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(
                height: 10,
              ),
              InputQuantity(
                controller: controller,
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
