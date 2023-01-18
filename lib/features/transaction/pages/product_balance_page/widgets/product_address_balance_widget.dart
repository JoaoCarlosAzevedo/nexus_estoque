import 'package:flutter/material.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/data/model/product_balance_model.dart';

class ProductAddressBalanceWidget extends StatefulWidget {
  const ProductAddressBalanceWidget(
      {super.key,
      required this.productBalance,
      required this.warehouseSelect,
      required this.onSelect});
  final ProductBalanceModel productBalance;
  final String warehouseSelect;
  final ValueChanged<String> onSelect;

  @override
  State<ProductAddressBalanceWidget> createState() =>
      _ProductAddressBalanceWidgetState();
}

class _ProductAddressBalanceWidgetState
    extends State<ProductAddressBalanceWidget> {
  var indexMarked = -1;
  var currentWarehouse = "";

  @override
  Widget build(BuildContext context) {
    final warehouse = widget.productBalance.armazem
        .firstWhere((element) => element.armz == widget.warehouseSelect);

    final addresses = warehouse.enderecos;

    if (widget.warehouseSelect != currentWarehouse) {
      indexMarked = -1;
    }

    return SizedBox(
      height: 400,
      child: ListView.builder(
        itemCount: addresses.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 200,
            //height: 50,
            child: Card(
              child: ListTile(
                onTap: () {
                  setState(() {
                    indexMarked = index;
                    currentWarehouse = widget.warehouseSelect;
                  });
                  widget.onSelect(addresses[indexMarked].codLocalizacao);
                },
                title: Text("Endereço: ${addresses[index].descEndereco}"),
                subtitle: Text(
                  "Saldo: ${addresses[index].quantidade.toString()}",
                ),
                leading: indexMarked != index
                    ? const Icon(Icons.radio_button_unchecked)
                    : const Icon(Icons.radio_button_checked),
              ),
            ),
          );
        },
      ),
    );
  }
}
