import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_estoque/core/pages/searches/products/pages/products_search_page.dart';

class ProductSelectionPage extends StatefulWidget {
  const ProductSelectionPage({super.key});

  @override
  State<ProductSelectionPage> createState() => _ProductSelectionPageState();
}

class _ProductSelectionPageState extends State<ProductSelectionPage> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 500),
      () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("TransferĂȘncia"),
        centerTitle: true,
        toolbarHeight: height / 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: height / 15, bottom: height / 15),
                child: SizedBox(
                  height: height / 10,
                  child: const FittedBox(
                    fit: BoxFit.cover,
                    child: FaIcon(
                      FontAwesomeIcons.boxesPacking,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: true,
                      autofocus: true,
                      controller: controller,
                      onSubmitted: (e) {
                        loadProduct(e);
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.qr_code),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            productSearchPage();
                          },
                          icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
                        ),
                        label: const Text("CĂłdigo de Barras"),
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
                  if (controller.text.isNotEmpty) {
                    loadProduct(controller.text);
                    controller.clear();
                  }
                },
                child: SizedBox(
                  height: height / 15,
                  width: double.infinity,
                  child: const Center(child: Text("Confirmar")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadProduct(String barcode) {
    context.push('/produtos/saldos/$barcode');
  }

  void productSearchPage() async {
    final String? result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const FractionallySizedBox(
          heightFactor: 0.9,
          child: ProductSearchPage(),
        );
      },
    );
    if (result != null) {
      controller.text = result;
    }
  }
}
