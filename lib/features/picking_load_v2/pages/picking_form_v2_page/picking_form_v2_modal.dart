import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/mixins/validation_mixin.dart';
import 'package:nexus_estoque/core/services/audio_player.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/input_quantity.dart';

import '../../../../core/widgets/form_input_no_keyboard_widget.dart';
import '../../data/model/pickingv2_model.dart';
import '../../data/repositories/pickingv2_repository.dart';
import '../picking_load_produts_list_page/widgets/picking_product_card_v2.dart';
import 'cubit/picking_save_v2_cubit.dart';

class PickingFormv2v2Modal {
  static Future<dynamic> show(context, Pickingv2Model picking) async {
    {
      final result = await showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.8,
            child: PickingFormv2(
              picking: picking,
            ),
          );
        },
      );
      if (result != null) {
        return result;
      } else {
        return '';
      }
    }
  }
}

class PickingFormv2 extends ConsumerStatefulWidget {
  const PickingFormv2({super.key, required this.picking});
  final Pickingv2Model picking;

  @override
  ConsumerState<PickingFormv2> createState() => _PickingFormv2State();
}

class _PickingFormv2State extends ConsumerState<PickingFormv2>
    with ValidationMixi {
  final formKey = GlobalKey<FormState>();

  final TextEditingController productController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final FocusNode productFocus = FocusNode();
  bool checkProduct = false;
  double quantity = 0;

  @override
  void dispose() {
    productController.dispose();
    addressController.dispose();
    productFocus.dispose();
    quantityController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    quantity = widget.picking.separado;
    quantityController.text = quantity.toString();
    quantityController.addListener(() {
      final double? newQuantity = double.tryParse(quantityController.text);

      if (newQuantity != null) {
        setState(() {
          quantity = newQuantity;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirma Separação"),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) =>
            PickingSavev2Cubit(ref.read(pickingv2RepositoryProvider)),
        child: BlocListener<PickingSavev2Cubit, PickingSavev2State>(
          listener: (context, state) {
            if (state is PickingSavev2Loaded) {
              Navigator.pop(context, 'ok');
            }
          },
          child: BlocBuilder<PickingSavev2Cubit, PickingSavev2State>(
            builder: (context, state) {
              if (state is PickingSavev2Loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is PickingSavev2Error) {
                return Center(
                  child: Text(state.failure.error),
                );
              }

              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                    child: Column(
                      children: [
                        PickingProductCardv2(
                          data: widget.picking,
                          onTap: (() {}),
                        ),
                        const Divider(),
                        /* TextFormField(
                          enabled: true,
                          validator: isNotEmpty,
                          onEditingComplete: () {},
                          onFieldSubmitted: (e) {
                            productFocus.requestFocus();
                          },
                          autofocus: true,
                          controller: addressController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.qr_code),
                            label: Text("Confirmação do Endereço"),

                          ),
                        ), */
                        NoKeyboardTextForm(
                          validator: isNotEmpty,
                          autoFocus: true,
                          controller: addressController,
                          label: "Confirmação do Endereço",
                          onSubmitted: (value) {
                            productFocus.requestFocus();
                          },
                        ),
                        const Divider(),
                        Text("Quant. Separada: $quantity"),
                        const Divider(),
                        /* TextFormField(
                          enabled: true,
                          focusNode: productFocus,
                          controller: productController,
                          onFieldSubmitted: (value) {
                            if (validateData()) {
                              productFocus.requestFocus();
                              increment(context, 1);
                            }
                            productController.clear();
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.qr_code),
                            label: Text("Confirmação do Produto"),
                          ),
                        ), */
                        NoKeyboardTextForm(
                          validator: isNotEmpty,
                          autoFocus: true,
                          focusNode: productFocus,
                          controller: productController,
                          label: "Confirmação do Produto",
                          onSubmitted: (value) {
                            if (validateData()) {
                              productFocus.requestFocus();
                              increment(context, 1);
                            }
                            productController.clear();
                          },
                        ),
                        const Divider(),
                        InputQuantity(
                          controller: quantityController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            submit(context);
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
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void increment(BuildContext context, double number) {
    double isPositive = quantity + number;

    if (isPositive >= 0) {
      setState(() {
        checkProduct = true;
      });

      AudioService.beep();
      setState(() {
        quantity = quantity + number;
        quantityController.text = quantity.toString();
      });

      if (quantity == widget.picking.quantidade) {
        //showValidation(context, "Quantidade superior ao reservado!");
        submit(context);
        return;
      }
    }
  }

  bool validateData() {
    bool addressValid = false;
    bool productValid = false;
    if (widget.picking.codEndereco.trim() == addressController.text.trim()) {
      addressValid = true;
    }

    if (widget.picking.codigo.trim() == productController.text.trim()) {
      productValid = true;
    }

    if (productController.text.trim().length >= 5) {
      if (widget.picking.codigobarras
          .trim()
          .contains(productController.text.trim())) {
        productValid = true;
      }
      if (widget.picking.codigobarras2
          .trim()
          .contains(productController.text.trim())) {
        productValid = true;
      }
    }

    if (!(addressValid && productValid)) {
      showValidation(context, "Produto ou Endereço inválido");
    }

    return addressValid && productValid;
  }

  void submit(BuildContext context) {
    final isValid = formKey.currentState!.validate();
    if (!checkProduct) {
      showValidation(context, "Produto inválido ou não informado");
      return;
    }
    if (isValid) {
      if (quantity <= 0) {
        showValidation(context, "Quantidade inválida");
        return;
      }

      if (quantity > widget.picking.quantidade) {
        showValidation(context, "Quantidade superior ao reservado!");
        return;
      }

      widget.picking.separado = quantity;
      context.read<PickingSavev2Cubit>().postPicking(widget.picking);
    }
  }

  void showValidation(context, String message) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            desc: message,
            btnOkOnPress: () {},
            btnOkColor: Theme.of(context).primaryColor)
        .show();
  }
}
