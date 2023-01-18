import 'package:flutter/material.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/data/model/product_balance_model.dart';

class ProductWarehouseBalanceWidget extends StatefulWidget {
  const ProductWarehouseBalanceWidget(
      {super.key, required this.productBalance, required this.onSelect});
  final ProductBalanceModel productBalance;
  final ValueChanged<String> onSelect;

  @override
  State<ProductWarehouseBalanceWidget> createState() =>
      _ProductWarehouseBalanceWidgetState();
}

class _ProductWarehouseBalanceWidgetState
    extends State<ProductWarehouseBalanceWidget> {
  var indexMarked = 0;

  @override
  void initState() {
    indexMarked = widget.productBalance.armazem.indexWhere(
        (element) => element.armz == widget.productBalance.localPadrao);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.productBalance.armazem;

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 200,
            //height: 50,
            child: Card(
              child: ListTile(
                onTap: () {
                  setState(() {
                    indexMarked = index;
                  });
                  widget.onSelect(list[indexMarked].armz);
                },
                title: Text("Armazérm: ${list[index].armz}"),
                subtitle: Text(
                  "Saldo: ${list[index].saldoLocal.toString()}",
                ),
                //trailing: Icon(Icons.radio_button_checked),
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
