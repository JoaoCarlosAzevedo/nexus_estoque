import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/mixins/validation_mixin.dart';
import 'package:nexus_estoque/core/services/audio_player.dart';
import 'package:nexus_estoque/features/picking/data/model/picking_model.dart';
import 'package:nexus_estoque/features/picking/data/repositories/picking_repository.dart';
import 'package:nexus_estoque/features/picking/pages/picking_form/cubit/picking_save_cubit.dart';
import 'package:nexus_estoque/features/picking/pages/picking_products_list/widgets/picking_product_card_wigdet.dart';
import '../../../transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/input_quantity_int.dart';

class PickingFormModal {
  static Future<dynamic> show(context, PickingModel picking) async {
    {
      final result = await showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.8,
            child: PickingForm(
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

class PickingForm extends ConsumerStatefulWidget {
  const PickingForm({super.key, required this.picking});
  final PickingModel picking;

  @override
  ConsumerState<PickingForm> createState() => _PickingFormState();
}

class _PickingFormState extends ConsumerState<PickingForm> with ValidationMixi {
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
    quantityController.removeListener(_quantityListener);

    super.dispose();
  }

  @override
  void initState() {
    quantity = widget.picking.separado;
    quantityController.text = quantity.toString();
    quantityController.addListener(_quantityListener);
    super.initState();
  }

  void _quantityListener() {
    final double? newQuantity = double.tryParse(quantityController.text);

    if (newQuantity != null && newQuantity != quantity) {
      setState(() {
        quantity = newQuantity;
      });
    }
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
            PickingSaveCubit(ref.read(pickingRepositoryProvider)),
        child: BlocListener<PickingSaveCubit, PickingSaveState>(
          listener: (context, state) {
            if (state is PickingSaveLoaded) {
              Navigator.pop(context, 'ok');
            }
          },
          child: BlocBuilder<PickingSaveCubit, PickingSaveState>(
            builder: (context, state) {
              if (state is PickingSaveLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is PickingSaveError) {
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
                        PickingProductCard(
                          data: widget.picking,
                          onTap: (() {}),
                        ),
                        const Divider(),
                        TextFormField(
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
                        ),
                        const Divider(),
                        Text("Quant. Separada: ${quantity.toInt()}"),
                        const Divider(),
                        TextFormField(
                          enabled: true,
                          focusNode: productFocus,
                          controller: productController,
                          onFieldSubmitted: (value) {
                            if (validateData()) {
                              productController.clear();
                              productFocus.requestFocus();
                              increment(context, 1);
                            }
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.qr_code),
                            label: Text("Confirmação do Produto"),
                          ),
                        ),
                        const Divider(),
                        /*  InputQuantity(
                          controller: quantityController,
                        ), */
                        InputQuantityInt(
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
      context.read<PickingSaveCubit>().postPicking(widget.picking);
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
