import 'package:flutter/material.dart';
import 'package:nexus_estoque/features/transactions/presentation/pages/transaction_form/widgets/input_field_widget.dart';

class TransctionFormPage extends StatefulWidget {
  const TransctionFormPage({super.key});

  @override
  State<TransctionFormPage> createState() => _TransctionFormPageState();
}

class _TransctionFormPageState extends State<TransctionFormPage> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movimentos"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).selectedRowColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Divider(),
                InputText(
                  name: "Local",
                  controller: controller,
                  onPressed: () {},
                ),
                const Divider(),
                InputText(
                  name: "Quantidade",
                  controller: controller,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
