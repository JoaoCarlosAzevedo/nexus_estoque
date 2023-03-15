import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/features/address/data/model/product_address_model.dart';
import 'package:nexus_estoque/features/address/pages/product_address_form_page/cubit/cubit/product_address_form_cubit.dart';

class ProductCheckPage extends StatefulWidget {
  const ProductCheckPage({super.key, required this.productAddress});
  final ProductAddressModel productAddress;

  @override
  State<ProductCheckPage> createState() => _ProductCheckPageState();
}

class _ProductCheckPageState extends State<ProductCheckPage> {
  final TextEditingController controller = TextEditingController();
  bool _validate = false;

  void hideKeyboard() {
    Future.delayed(
      const Duration(milliseconds: 500),
      () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
    );
  }

  @override
  void initState() {
    hideKeyboard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
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
                    FontAwesomeIcons.clipboardCheck,
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
                      checkProductCode(e);
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.qr_code),
                      label: const Text("Código de Barras / SKU"),
                      errorText: _validate ? 'Produto incorreto!' : null,
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
                checkProductCode(controller.text);
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
    );
  }

  void checkProductCode(String code) {
    final cubit = BlocProvider.of<ProductAddressFormCubit>(context);

    if (code.trim().isEmpty) {
      setState(() {
        _validate = true;
      });
      return;
    }

    if (widget.productAddress.codigo.trim() == code.trim()) {
      cubit.checkProduct();
      return;
    }

    if (widget.productAddress.codigoBarras.contains(code.trim()) &&
        code.trim().length > 6) {
      cubit.checkProduct();
      return;
    }
    setState(() {
      _validate = true;
    });
  }
}
