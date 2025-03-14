import 'package:awesome_dialog/awesome_dialog.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/features/product_balance/data/repositories/product_balance_repository.dart';
import 'package:nexus_estoque/core/features/product_balance/pages/product_selection/cubit/product_balance_cubit.dart';
import 'package:nexus_estoque/core/features/searches/addresses/data/model/address_model.dart';
import 'package:nexus_estoque/core/features/searches/addresses/page/address_search_page.dart';
import 'package:nexus_estoque/features/address/data/model/product_address_model.dart';
import 'package:nexus_estoque/features/address/data/repositories/product_address_repository.dart';
import 'package:nexus_estoque/features/address/pages/product_address_form_page/cubit/cubit/product_address_form_cubit.dart';
import 'package:nexus_estoque/features/address/pages/product_address_form_page/cubit/cubit/product_address_form_state.dart';
import 'package:nexus_estoque/features/address/pages/product_address_form_page/widgets/product_info_widget.dart';
import 'package:nexus_estoque/features/address/pages/product_check_page/product_check_page.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/input_quantity.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/input_text.dart';

import '../../../../core/features/product_multiplier/pages/product_multiplier_modal.dart';
import '../../../../core/widgets/form_input_no_keyboard_widget.dart';

class AddressForm extends ConsumerStatefulWidget {
  const AddressForm({super.key, required this.productAddress});
  final ProductAddressModel productAddress;

  @override
  ConsumerState<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends ConsumerState<AddressForm> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController batchController = TextEditingController();
  final TextEditingController productController = TextEditingController();
  final TextEditingController quantityController =
      TextEditingController(text: '0');

  final addressFocus = FocusNode();
  final batchFocus = FocusNode();
  final quantityFocus = FocusNode();
  final productFocus = FocusNode();

  bool isMultiple = false;

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
    addressFocus.dispose();
    batchFocus.dispose();
    addressController.dispose();
    quantityController.dispose();
    productController.dispose();
    batchController.dispose();
    quantityFocus.dispose();
    productFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //backgroundColor: AppColors.background,
        title: const Text("Endereçamento"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            color: Colors.green,
            //style: IconButton.styleFrom(hoverColor: Colors.green),
            onPressed: () async {
              final isSuccess = await showProductMultiplierModal(
                  context, widget.productAddress.codigo);
              if (isSuccess) {
                // ignore: use_build_context_synchronously
                context.pop(true);
              }
            },
          ),
        ],
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
              context.pop(true);
            }
          },
          child: BlocBuilder<ProductAddressFormCubit, ProductAddressFormState>(
            builder: (context, state) {
              if (state is ProductAddressFormCheck) {
                return ProductCheckPage(
                  productAddress: widget.productAddress,
                );
              }
              if (state is ProductAddressFormLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ProductInfo(
                        productAddress: widget.productAddress,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
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
                              quantityFocus.requestFocus();
                            },
                            onSubmitted: () {
                              batchFocus.requestFocus();
                              quantityFocus.requestFocus();
                            },
                            focus: addressFocus,
                          ),
                          if (widget.productAddress.lote.trim().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: TextField(
                                enabled: true,
                                controller: batchController,
                                focusNode: batchFocus,
                                onSubmitted: (e) {},
                                decoration: const InputDecoration(
                                  label: Text("Lote"),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.qr_code),
                                ),
                              ),
                            ),
                          if (widget.productAddress.fator > 0)
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 5,
                              direction: Axis.horizontal,
                              children: [
                                Text(
                                    "Utiliza Multiplicador ${widget.productAddress.fator} ?"),
                                Switch(
                                  value: isMultiple,
                                  activeColor: Colors.green,
                                  inactiveTrackColor: Colors.grey,
                                  onChanged: (bool value) {
                                    // This is called when the user toggles the switch.
                                    setState(() {
                                      isMultiple = value;
                                    });
                                    if (isMultiple) {
                                      productFocus.requestFocus();
                                    } else {
                                      quantityFocus.requestFocus();
                                    }
                                  },
                                ),
                              ],
                            ),
                          if (widget.productAddress.fator > 0 && isMultiple)
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: NoKeyboardTextForm(
                                autoFocus: true,
                                label: 'Cód. Produto',
                                controller: productController,
                                focusNode: productFocus,
                                onChange: false,
                                onSubmitted: (e) {
                                  if (checkProductCode(e)) {
                                    setState(() {
                                      _addValue(
                                          1 * widget.productAddress.fator);
                                    });
                                  }

                                  productController.clear();
                                  productFocus.requestFocus();
                                },
                              ),
                            ),
                          const Divider(),
                          InputQuantity(
                            controller: quantityController,
                            focus: quantityFocus,
                            fator:
                                isMultiple ? widget.productAddress.fator : null,
                          ),
                          const Divider(),
                          ElevatedButton(
                            onPressed: () {
                              if (widget.productAddress.lote
                                  .trim()
                                  .isNotEmpty) {
                                if (batchController.text.trim().isEmpty) {
                                  AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.error,
                                          animType: AnimType.rightSlide,
                                          //title: 'Alerta',
                                          desc: "Campo Lote não preenchido!",
                                          //btnCancelOnPress: () {},
                                          btnOkOnPress: () {},
                                          btnOkColor:
                                              Theme.of(context).primaryColor)
                                      .show();
                                  return;
                                }
                              }

                              final cubit =
                                  BlocProvider.of<ProductAddressFormCubit>(
                                      context);
                              cubit.postProductAddress(
                                  widget.productAddress.codigo,
                                  widget.productAddress.numseq,
                                  addressController.text,
                                  double.parse(quantityController.text),
                                  batchController.text);
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
    final repository = ref.read(productBalanceRepositoryProvider);
    final result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: BlocProvider(
            create: (context) => ProductBalanceCubit(repository,
                code: widget.productAddress.codigo),
            child: BlocListener<ProductBalanceCubit, ProductBalanceCubitState>(
              listener: (context, state) {
                if (state is ProductBalanceCubitError) {
                  showError(context, state.error.error);
                }
              },
              child: BlocBuilder<ProductBalanceCubit, ProductBalanceCubitState>(
                builder: (context, state) {
                  if (state is ProductBalanceCubitLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is ProductBalanceCubitLoaded) {
                    BalanceWarehouse? addresses = state.productBalance.armazem
                        .firstWhereOrNull((element) =>
                            element.codigo == widget.productAddress.armazem);

                    return AddressSearchPage(
                      warehouse: widget.productAddress.armazem,
                      data: addresses != null ? addresses.enderecos : [],
                    );
                  }

                  return const Center(
                    child: Text("Erro ao carregar dados do produto"),
                  );
                },
              ),
            ),
            /*  child: AddressSearchPage(
              warehouse: widget.productAddress.armazem,
              data: const [],
            ), */
          ),
        );
      },
    );
    if (result is AddressModel) {
      addressController.text = result.codigo;
    }
  }

  bool checkProductCode(String code) {
    if (widget.productAddress.codigo.trim() == code.trim()) {
      return true;
    }

    if (widget.productAddress.codigoBarras.contains(code.trim()) &&
        code.trim().length > 6) {
      return true;
    }

    if (widget.productAddress.codigoBarras2.contains(code.trim()) &&
        code.trim().length > 6) {
      return true;
    }

    return false;
  }

  void _addValue(double number) {
    if (quantityController.text.isEmpty) {
      quantityController.text = '0';
    }

    double isPositive = double.parse(quantityController.text) + number;

    if (isPositive >= 0) {
      quantityController.text =
          (double.parse(quantityController.text) + number).toStringAsFixed(2);

      quantityController.selection =
          TextSelection.collapsed(offset: quantityController.text.length);
    }
  }
}

void showError(context, String error) {
  AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          desc: error,
          btnOkOnPress: () {},
          btnOkColor: Theme.of(context).primaryColor)
      .show();
}
