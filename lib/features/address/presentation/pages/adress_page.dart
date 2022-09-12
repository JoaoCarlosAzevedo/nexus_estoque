import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Endereçamento"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 25.0, 8.0, 8.0),
        child: Column(
          children: [
            const TextField(
              enabled: true,
              autofocus: false,
              decoration: InputDecoration(
                label: Text("Código"),
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.qr_code_scanner_rounded),
                hintText: "Código ou descriçao do produto",
              ),
            ),
            ListTile(
              onTap: () {},
              title: Text("PRODUTO 1   PRODUTO 1   "),
              subtitle: Text("000000000000001"),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Local 02"),
                  Text("Saldo: 13"),
                ],
              ),
              visualDensity: VisualDensity.compact,
            ),
            ListTile(
              onTap: () {},
              title: Text("PRODUTO 3   PRODUTO 3   "),
              subtitle: Text("000000000000001"),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Local 01"),
                  Text("Saldo: 123456.23"),
                ],
              ),
              visualDensity: VisualDensity.compact,
            )
          ],
        ),
      ),
    );
  }
}
