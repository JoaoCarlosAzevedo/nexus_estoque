import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/mixins/validation_mixin.dart';
import 'package:nexus_estoque/core/services/audio_player.dart';
import 'package:nexus_estoque/features/picking_load_v2/pages/picking_form_v2_page/picking_form_serial_modal.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/input_quantity.dart';

import '../../../../core/utils/error_dialog.dart';
import '../../../../core/widgets/form_input_no_keyboard_widget.dart';
import '../../data/model/pickingv2_model.dart';
import '../../data/repositories/pickingv2_repository.dart';
import '../picking_load_produts_list_page/widgets/picking_product_card_v2.dart';
import 'cubit/picking_save_v2_cubit.dart';

class PickingFormv3Modal {
  static Future<dynamic> show(context, Pickingv2Model picking) async {
    {
      final result = await showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.8,
            child: PickingFormv3(
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

class PickingFormv3 extends ConsumerStatefulWidget {
  const PickingFormv3({super.key, required this.picking});
  final Pickingv2Model picking;

  @override
  ConsumerState<PickingFormv3> createState() => _PickingFormv3State();
}

class _PickingFormv3State extends ConsumerState<PickingFormv3>
    with ValidationMixi {
  final formKey = GlobalKey<FormState>();

  final TextEditingController productController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController serialController = TextEditingController();
  final FocusNode productFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();
  final FocusNode serialFocus = FocusNode();
  List<String> seriais = [];

  bool checkProduct = false;
  double quantity = 0;
  bool isMultiple = false;

  @override
  void dispose() {
    productController.dispose();
    addressController.dispose();
    serialController.dispose();
    productFocus.dispose();
    addressFocus.dispose();
    serialFocus.dispose();
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

              ///TO DO FATOR
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
                        NoKeyboardTextForm(
                          validator: isNotEmpty,
                          autoFocus: true,
                          controller: addressController,
                          focusNode: addressFocus,
                          label: "Confirmação do Endereço",
                          onSubmitted: (value) {
                            bool isValid = validateAddress();

                            if (isValid) {
                              productFocus.requestFocus();
                            } else {
                              showErrorWidget(context, "Endereço inválido");
                              addressController.clear();
                              addressFocus.requestFocus();
                            }
                          },
                        ),
                        //const Divider(),
                        Text("Quant. Separada: $quantity"),
                        const Divider(),
                        /* if (widget.picking.fator > 0)
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 5,
                            direction: Axis.horizontal,
                            children: [
                              Text(
                                  "Utiliza Multiplicador ${widget.picking.fator}x ?"),
                              Switch(
                                value: isMultiple,
                                activeColor: Colors.green,
                                inactiveTrackColor: Colors.grey,
                                onChanged: (bool value) {
                                  // This is called when the user toggles the switch.
                                  setState(() {
                                    isMultiple = value;
                                  });
                                  productFocus.requestFocus();
                                },
                              ),
                            ],
                          ), */
                        //const Divider(),
                        NoKeyboardTextForm(
                          autoFocus: true,
                          focusNode: productFocus,
                          controller: productController,
                          label: "Confirmação do Produto",
                          onSubmitted: (value) {
                            if (validateData()) {
                              if (widget.picking.serial == 'S') {
                                serialFocus.requestFocus();
                              } else {
                                productFocus.requestFocus();
                                if (isMultiple) {
                                  increment(context, 1 * widget.picking.fator);
                                } else {
                                  increment(context, 1);
                                }
                                productController.clear();
                              }
                            } else {
                              productFocus.requestFocus();
                              productController.clear();
                            }
                          },
                        ),
                        //const Divider(),
                        if (widget.picking.serial == 'S')
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: NoKeyboardTextForm(
                                  autoFocus: true,
                                  focusNode: serialFocus,
                                  controller: serialController,
                                  label: "Número de Série",
                                  onSubmitted: (value) {
                                    if (validateData()) {
                                      if (value.isNotEmpty) {
                                        seriais.add(value);
                                        increment2(context, 1);
                                        serialController.clear();
                                        serialFocus.requestFocus();
                                      }
                                    } else {
                                      serialController.clear();
                                      productFocus.requestFocus();
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () async {
                                  final qtdSerials = await SerialListModal.show(
                                      context, widget.picking, seriais);
                                  log(qtdSerials.toString());
                                  log(seriais.toString());
                                  //zera quantidade atual, e grava nova por cima
                                  // ignore: use_build_context_synchronously
                                  if (qtdSerials != quantity) {
                                    setState(() {
                                      quantity = 0;
                                    });
                                    // ignore: use_build_context_synchronously
                                    increment2(context, qtdSerials);
                                  }
                                },
                              ),
                            ],
                          ),
                        if (widget.picking.serial != 'S')
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
    var isDun = false;
    double fator = widget.picking.fator;
    double addQuantity = 0;

    if (productController.text.trim() == widget.picking.codigobarras2.trim()) {
      isDun = true;
    }

    if (fator > 0 && isDun) {
      isPositive = quantity + number * fator;
      addQuantity = number * fator;
    } else {
      isPositive = quantity + number;
      addQuantity = number;
    }

    if (isPositive >= 0) {
      setState(() {
        checkProduct = true;
      });

      if (quantity + number > 0) {
        AudioService.beep();
      }
      setState(() {
        quantity = quantity + addQuantity;
        quantityController.text = quantity.toString();
      });
    }
  }

  void increment2(BuildContext context, double number) {
    double isPositive = quantity + number;

    if (isPositive >= 0) {
      setState(() {
        checkProduct = true;
      });

      if (quantity + number > 0) {
        AudioService.beep();
      }

      setState(() {
        quantity = widget.picking.calcSerialSkuQuantity(seriais.length);
        quantityController.text = quantity.toString();
      });
    }
  }

  bool validateAddress() {
    if (widget.picking.codEndereco.trim() == addressController.text.trim()) {
      return true;
    }

    return false;
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
      if (widget.picking.codigobarras.trim() ==
          (productController.text.trim())) {
        productValid = true;
      }
      if (widget.picking.codigobarras2.trim() ==
          (productController.text.trim())) {
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

      if (widget.picking.serial == 'S') {
        if (seriais.length.toDouble() != widget.picking.qtdMax) {
          showValidation(context, "Número de Séries diferente da quantidade");
          return;
        }
      }

      widget.picking.separado = quantity;
      context.read<PickingSavev2Cubit>().postPicking(widget.picking, seriais);
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
