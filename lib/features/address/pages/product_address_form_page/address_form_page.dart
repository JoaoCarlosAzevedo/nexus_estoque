import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/searches/addresses/data/model/address_model.dart';
import 'package:nexus_estoque/core/features/searches/addresses/page/address_search_page.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';
import 'package:nexus_estoque/features/address/data/model/product_address_model.dart';
import 'package:nexus_estoque/features/address/data/repositories/product_address_repository.dart';
import 'package:nexus_estoque/features/address/pages/product_address_form_page/cubit/cubit/product_address_form_cubit.dart';
import 'package:nexus_estoque/features/address/pages/product_address_form_page/cubit/cubit/product_address_form_state.dart';
import 'package:nexus_estoque/features/address/pages/product_address_form_page/widgets/product_info_widget.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/input_quantity.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/input_text.dart';

class AddressForm extends ConsumerStatefulWidget {
  const AddressForm({super.key, required this.productAddress});
  final ProductAddressModel productAddress;

  @override
  ConsumerState<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends ConsumerState<AddressForm> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController quantityController =
      TextEditingController(text: '0');

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
    addressController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text("Endereçamento"),
      ),
      body: BlocProvider(
        create: (context) =>
            ProductAddressFormCubit(ref.read(productAddressRepository)),
        child: BlocListener<ProductAddressFormCubit, ProductAddressFormState>(
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
                            autoFocus: true,
                            controller: addressController,
                            label: "Endereço",
                            enabled: true,
                            onPressed: () async {
                              addressSearchPage();
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
      ),
    );
  }

  void addressSearchPage() async {
    final result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
            heightFactor: 0.9,
            child: AddressSearchPage(
              warehouse: widget.productAddress.armazem,
              data: const [],
            ));
      },
    );
    if (result is AddressModel) {
      addressController.text = result.codigo;
    }
  }
}
