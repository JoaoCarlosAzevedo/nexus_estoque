import 'package:flutter/material.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/data/model/product_balance_model.dart';

class AddressBalance extends StatelessWidget {
  final List<Enderecos> addressBalance;

  const AddressBalance({
    Key? key,
    required this.addressBalance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saldo por Armazém"),
      ),
      body: ListView.builder(
        itemCount: addressBalance.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(addressBalance[index].descEndereco),
              subtitle: Text("Saldo: ${addressBalance[index].quantidade}"),
              onTap: () {
                Navigator.pop(context, addressBalance[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
