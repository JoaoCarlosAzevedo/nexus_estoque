import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/features/address/data/model/product_address_model.dart';
import 'package:nexus_estoque/features/address/presentation/pages/product_address_form_page/cubit/cubit/product_address_form_cubit.dart';
import 'package:nexus_estoque/features/address/presentation/pages/product_address_form_page/cubit/cubit/product_address_form_state.dart';
import 'package:nexus_estoque/features/address/presentation/pages/product_address_form_page/widgets/product_info_widget.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({super.key, required this.productAddress});
  final ProductAddressModel productAddress;

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
      body: BlocListener<ProductAddressFormCubit, ProductAddressFormState>(
        listener: (context, state) {
          if (state is ProductAddressFormValidation) {
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    //title: 'Alerta',
                    desc: state.failure.error,
                    //btnCancelOnPress: () {},
                    btnOkOnPress: () {},
                    btnOkColor: Theme.of(context).primaryColor)
                .show();
          }
          if (state is ProductAddressFormSuccess) {
            Navigator.pop(context);
            //Navigator.pushNamed(context, '/enderecas');
          }
        },
        child: BlocBuilder<ProductAddressFormCubit, ProductAddressFormState>(
          builder: (context, state) {
            if (state is ProductAddressFormLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
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
                                    final result = await Navigator.pushNamed(
                                        context, '/enderecos');
                                    if (result != null) {
                                      addressController.text = result as String;
                                    } else {
                                      addressController.clear();
                                    }
                                  },
                                  icon: const FaIcon(
                                      FontAwesomeIcons.magnifyingGlass),
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
                            onPressed: () {
                              final cubit =
                                  BlocProvider.of<ProductAddressFormCubit>(
                                      context);
                              cubit.postProductAddress(
                                  widget.productAddress.codigo,
                                  widget.productAddress.numseq,
                                  addressController.text,
                                  double.parse(quantityController.text));

                              /*   final result = await postAddress();
                                  print(result); */
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
            );
          },
        ),
      ),
    );
  }
}
