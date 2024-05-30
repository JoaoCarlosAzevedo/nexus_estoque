import 'package:flutter/material.dart';
import 'package:nexus_estoque/core/features/searches/addresses/data/model/address_model.dart';

class AddressBalance extends StatelessWidget {
  final List<AddressModel> addressBalance;

  const AddressBalance({
    super.key,
    required this.addressBalance,
  });

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
              title: Text(addressBalance[index].descricao),
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
