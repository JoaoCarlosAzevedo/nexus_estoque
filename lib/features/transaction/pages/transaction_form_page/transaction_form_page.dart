import 'package:flutter/material.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/data/model/product_balance_model.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form/widgets/input_quantity.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form/widgets/input_text.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form/widgets/produc_transfer_card.dart';

class TransactionFormPage extends StatefulWidget {
  const TransactionFormPage({super.key});

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*           ProductTransferCard(
              productDetail: widget.productDetail,
            ), */
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Origem",
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Divider(),
                  InputText(
                    label: "Local",
                    focus: FocusNode(),
                    controller: TextEditingController(),
                    enabled: true,
                    onPressed: () {
                      //warehouseSearch();
                    },
                    onSubmitted: () {
                      //origAddressFocus.requestFocus();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputText(
                    label: "Endereços",
                    focus: FocusNode(),
                    controller: TextEditingController(),
                    enabled: true,
                    onPressed: () {
                      //addressSearch();
                    },
                    onSubmitted: () {
                      //destAddressFocus.requestFocus();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputText(
                    label: "Lote",
                    focus: FocusNode(),
                    controller: TextEditingController(),
                    enabled: true,
                    onPressed: () {
                      //addressSearch();
                    },
                    onSubmitted: () {
                      //destAddressFocus.requestFocus();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Destino",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  InputQuantity(
                    controller: TextEditingController(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //postTransfer();
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Center(child: Text("Confirmar")),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
