import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/features/address/data/model/product_address_model.dart';
import 'package:nexus_estoque/features/address/data/repositories/product_address_repository.dart';
import 'package:nexus_estoque/features/address/presentation/pages/address_list_page/cubit/product_address_cubit.dart';
import 'package:nexus_estoque/features/address/presentation/pages/product_address_form_page/widgets/product_info_widget.dart';
import 'package:nexus_estoque/features/query_address/presentantion/pages/query_address_page.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({super.key, required this.productAddress});
  final ProductAddress productAddress;

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Endereçamento"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ProductInfo(
                productAddress: widget.productAddress,
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).selectedRowColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: addressController,
                            enabled: true,
                            autofocus: false,
                            decoration: const InputDecoration(
                              label: Text("Endereço"),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              var test = await showSearch(
                                  context: context, delegate: SearchAddress());
                              addressController.text = test!;
                            },
                            icon:
                                const FaIcon(FontAwesomeIcons.magnifyingGlass),
                          ),
                        )
                      ],
                    ),
                    const Divider(),
                    TextField(
                      controller: quantityController,
                      enabled: true,
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text("Quantidade"),
                      ),
                    ),
                    const Divider(),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await postAddress();
                        print(result);
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> postAddress() async {
    final ProductAddressRepository repository = ProductAddressRepository();
    final response = await repository.addressProduct(
      widget.productAddress.codigo,
      widget.productAddress.numseq,
      addressController.text,
      double.parse(quantityController.text),
    );
    return response.fold((l) => l.error, (r) => r);
  }
}
