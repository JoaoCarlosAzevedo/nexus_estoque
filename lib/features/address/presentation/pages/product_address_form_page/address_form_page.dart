import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';
import 'package:nexus_estoque/features/address/data/model/product_address_model.dart';
import 'package:nexus_estoque/features/address/presentation/pages/product_address_form_page/cubit/cubit/product_address_form_cubit.dart';
import 'package:nexus_estoque/features/address/presentation/pages/product_address_form_page/cubit/cubit/product_address_form_state.dart';
import 'package:nexus_estoque/features/address/presentation/pages/product_address_form_page/widgets/product_info_widget.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_transfer_form/widgets/input_quantity.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_transfer_form/widgets/input_text.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({super.key, required this.productAddress});
  final ProductAddressModel productAddress;

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController quantityController =
      TextEditingController(text: '0');
  @override
  void dispose() {
    addressController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
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
              child: Column(
                children: [
                  ProductInfo(
                    productAddress: widget.productAddress,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).selectedRowColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        InputText(
                          controller: addressController,
                          label: "Endereço",
                          enabled: true,
                          onPressed: () async {
                            final result = await Navigator.pushNamed(
                                context, '/enderecos',
                                arguments: widget.productAddress.armazem);
                            if (result != null) {
                              addressController.text = result as String;
                            } else {
                              addressController.clear();
                            }
                          },
                          onSubmitted: () {},
                          focus: FocusNode(),
                        ),
                        const Divider(),
                        InputQuantity(controller: quantityController),
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
            );
          },
        ),
      ),
    );
  }
}
