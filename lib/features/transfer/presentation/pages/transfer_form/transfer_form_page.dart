import 'package:flutter/material.dart';
import 'package:nexus_estoque/features/transactions/presentation/pages/transaction_form/widgets/input_field_widget.dart';

class TransferFormPage extends StatefulWidget {
  const TransferFormPage({super.key});

  @override
  State<TransferFormPage> createState() => _TransferFormPageState();
}

class _TransferFormPageState extends State<TransferFormPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(),
          body: _selectedIndex == 0
              ? const Page1()
              : const Center(
                  child: Text("Page 2"),
                ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Origem',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'Destino',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Text("Produto"),
            InputText(
              onPressed: () {},
              controller: TextEditingController(),
              name: "Endereço",
            ),
            Divider(),
            InputText(
              onPressed: () {},
              controller: TextEditingController(),
              name: "Quantidade",
            ),
          ],
        ),
      ),
    );
  }
}
