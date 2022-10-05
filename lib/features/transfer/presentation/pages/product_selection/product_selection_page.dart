import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductSelectionPage extends StatefulWidget {
  const ProductSelectionPage({super.key});

  @override
  State<ProductSelectionPage> createState() => _ProductSelectionPageState();
}

class _ProductSelectionPageState extends State<ProductSelectionPage> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transferência"),
        centerTitle: true,
        toolbarHeight: height / 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: height / 15, bottom: height / 15),
              child: SizedBox(
                height: height / 10,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: FaIcon(
                    FontAwesomeIcons.boxesPacking,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: true,
                    autofocus: false,
                    controller: controller,
                    onSubmitted: (e) {
                      print("onSubmitted: $e");
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.qr_code),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          final result =
                              await Navigator.pushNamed(context, '/produtos');
                          if (result != null) {
                            controller.text = result as String;
                          } else {
                            controller.clear();
                          }
                          print(result);
                        },
                        icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
                      ),
                      //icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
                      label: const Text("Código de Barras"),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height / 20,
            ),
            ElevatedButton(
              onPressed: () {
                loadProduct(controller.text);
              },
              child: SizedBox(
                height: height / 15,
                width: double.infinity,
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Center(child: Text("Confirmar")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadProduct(String barcode) {
    Navigator.pushNamed(context, '/produtos/saldos', arguments: barcode);
  }
}