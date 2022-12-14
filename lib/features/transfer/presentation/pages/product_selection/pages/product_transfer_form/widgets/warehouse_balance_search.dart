import 'package:flutter/material.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/data/model/product_balance_model.dart';

class WarehouseBalanceSearch extends StatelessWidget {
  final List<Armazem> warehouseBalances;

  const WarehouseBalanceSearch({
    Key? key,
    required this.warehouseBalances,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saldo por Armazém"),
      ),
      body: ListView.builder(
        itemCount: warehouseBalances.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text("Armazém: ${warehouseBalances[index].armz}"),
              subtitle: Text("Saldo: ${warehouseBalances[index].saldoLocal}"),
              onTap: () {
                Navigator.pop(context, warehouseBalances[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
