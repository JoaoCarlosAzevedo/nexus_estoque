import 'package:flutter/material.dart';
import 'package:nexus_estoque/features/transaction/pages/product_balance_page/widgets/product_address_balance_widget.dart';
import 'package:nexus_estoque/features/transaction/pages/product_balance_page/widgets/product_balance_header_widget.dart';
import 'package:nexus_estoque/features/transaction/pages/product_balance_page/widgets/product_batches_balance_widget.dart';
import 'package:nexus_estoque/features/transaction/pages/product_balance_page/widgets/product_warehous_balance_widget.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/data/model/product_balance_model.dart';

class ProductBalanceWidget extends StatefulWidget {
  const ProductBalanceWidget({
    Key? key,
    required this.product,
  }) : super(key: key);
  final ProductBalanceModel product;
  @override
  State<ProductBalanceWidget> createState() => _ProductBalanceWidgetState();
}

class _ProductBalanceWidgetState extends State<ProductBalanceWidget> {
  String warehouse = '';
  String address = '';

  @override
  void initState() {
    warehouse = widget.product.localPadrao;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("armaze: $warehouse  endereço: $address");
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductBalanceHeader(
            productBalance: widget.product,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductWarehouseBalanceWidget(
              productBalance: widget.product,
              onSelect: (value) => setState(() {
                warehouse = value;
                address = "";
              }),
            ),
          ),
          ProductBatchBalanceWidget(
            productBalance: widget.product,
            warehouseSelect: warehouse,
            onSelect: ((value) => print(value)),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Endereços"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductAddressBalanceWidget(
              productBalance: widget.product,
              warehouseSelect: warehouse,
              onSelect: ((value) => setState(() {
                    address = value;
                  })),
            ),
          )
        ],
      ),
    );
  }
}
