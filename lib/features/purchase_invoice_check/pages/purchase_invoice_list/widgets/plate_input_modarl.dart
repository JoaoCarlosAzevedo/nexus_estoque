import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/purchase_invoice_model.dart';
import '../../../data/repositories/purchase_invoice_repository.dart';
import '../provider/plate_number_provider.dart';

Future<bool> showPlateInputModal(
    BuildContext context, List<PurchaseInvoice> invoices) async {
  final response = await showDialog<bool>(
      context: context,
      builder: (_) => PlateInputModal(
            invoices: invoices,
          ));
  if (response == null) {
    return false;
  }
  return response;
}

class PlateInputModal extends ConsumerStatefulWidget {
  const PlateInputModal({super.key, required this.invoices});
  final List<PurchaseInvoice> invoices;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlateInputModalState();
}

class _PlateInputModalState extends ConsumerState<PlateInputModal> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(plateNumberProvider);
    ref.listen(plateNumberProvider, (previous, current) {
      if (current is AsyncData) {
        if (current.value ?? false) {
          ref.invalidate(purchaseInvoicesProvider);
          Navigator.pop(context, true);
        }

        if (!(current.value ?? false)) {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  desc: "Erro ao gravar placa!",
                  btnOkOnPress: () {},
                  btnOkColor: Theme.of(context).primaryColor)
              .show();
        }
      }

      if (current is AsyncError) {
        AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                desc: current.error.toString(),
                btnOkOnPress: () {},
                btnOkColor: Theme.of(context).primaryColor)
            .show();
      }
    });

    return AlertDialog(
      content: SizedBox(
        width: 200,
        height: 200,
        child: provider.when(
            skipLoadingOnRefresh: false,
            data: (data) {
              return ListView(
                shrinkWrap: true,
                children: [
                  const Text("Número da Placa"),
                  const Divider(),
                  TextFormField(
                    onChanged: (value) {
                      controller.text = value.toUpperCase();
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]'))
                    ],
                    autofocus: true,
                    textCapitalization: TextCapitalization.characters,
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'Ex. HCT1234'),
                  ),
                  const Divider(),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        ref
                            .read(plateNumberProvider.notifier)
                            .postPlateNumber(controller.text, widget.invoices);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Confirmar"),
                    ),
                  ),
                ],
              );
            },
            error: (_, __) => ListView(
                  shrinkWrap: true,
                  children: [
                    const Text("Número da Placa"),
                    const Divider(),
                    TextFormField(
                      onChanged: (value) {
                        controller.text = value.toUpperCase();
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]'))
                      ],
                      autofocus: true,
                      textCapitalization: TextCapitalization.characters,
                      controller: controller,
                      decoration:
                          const InputDecoration(hintText: 'Ex. HCT1234'),
                    ),
                    const Divider(),
                    ElevatedButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          ref
                              .read(plateNumberProvider.notifier)
                              .postPlateNumber(
                                  controller.text, widget.invoices);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Confirmar"),
                      ),
                    ),
                  ],
                ),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )),
      ),
      /* actions: [
        ElevatedButton(
          onPressed: () { 
            if (controller.text.isNotEmpty) {
              ref
                  .read(plateNumberProvider.notifier)
                  .postPlateNumber(controller.text, widget.invoices);
            }
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Confirmar"),
          ),
        ),
      ], */
    );
  }
}
