import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/mixins/validation_mixin.dart';
import 'package:nexus_estoque/features/picking/data/model/picking_model.dart';
import 'package:nexus_estoque/features/picking/data/repositories/picking_repository.dart';
import 'package:nexus_estoque/features/picking/pages/picking_form/cubit/picking_save_cubit.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/input_quantity.dart';

class PickingFormModal {
  static Future<dynamic> show(context, PickingModel picking) async {
    {
      final result = await showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.7,
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
  final TextEditingController quantityController =
      TextEditingController(text: '1.00');
  final FocusNode productFocus = FocusNode();

  @override
  void dispose() {
    productController.dispose();
    addressController.dispose();
    quantityController.dispose();
    productFocus.dispose();
    super.dispose();
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
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
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
                        TextFormField(
                          enabled: true,
                          validator: isNotEmpty,
                          focusNode: productFocus,
                          controller: productController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.qr_code),
                            label: Text("Confirmação do Produto"),
                          ),
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
    }

    return addressValid && productValid;
  }

  void submit(BuildContext context) {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      if (!validateData()) {
        showValidation(context, "Produto ou Endereço inválido");
      } else {
        final double quantity = double.tryParse(quantityController.text) ?? 0.0;

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
