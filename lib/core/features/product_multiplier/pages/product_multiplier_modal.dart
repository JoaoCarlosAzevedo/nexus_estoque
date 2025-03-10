import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/product_multiplier_model.dart';
import '../provider/product_multiplier_notifier.dart';

Future<bool> showProductMultiplierModal(
    BuildContext context, String barcode) async {
  final response = await showDialog<bool>(
      context: context,
      builder: (_) => ProductMultiplierModal(
            barcode: barcode,
          ));
  if (response == null) {
    return false;
  }
  return response;
}

class ProductMultiplierModal extends ConsumerStatefulWidget {
  const ProductMultiplierModal({super.key, required this.barcode});
  final String barcode;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductMultiplierModalState();
}

class _ProductMultiplierModalState
    extends ConsumerState<ProductMultiplierModal> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller.text = '0';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(remoteProductMultiplierProvider(widget.barcode));
    final provider2 = ref.watch(productMultiplierChangeProvider);

    ref.listen(productMultiplierChangeProvider, (previous, current) {
      if (current is AsyncData) {
        if (current.value ?? false) {
          Navigator.pop(context, true);
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
            //so atualiza ao carregar
            if (controller.text == '0') {
              controller.text = (data.multiplier).toStringAsFixed(2);

              controller.selection =
                  TextSelection.collapsed(offset: controller.text.length);
            }

            return ListView(
              shrinkWrap: true,
              children: [
                const Text("Produto"),
                Text(
                  data.descricao,
                  overflow: TextOverflow.ellipsis,
                ),
                const Divider(),
                TextField(
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  onChanged: (e) {
                    var doubleParsed = double.tryParse(e);

                    if (doubleParsed != null) {
                      if (double.parse(e) <= 0) {
                        controller.text = '0';
                        controller.selection = TextSelection.collapsed(
                            offset: controller.text.length);
                      }
                    }
                  },
                ),
                const Divider(),
                provider2.when(
                  data: (data) => ElevatedButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        final product = ProductMultiplierModel(
                            codigo: widget.barcode,
                            descricao: '',
                            multiplier: double.parse(controller.text));

                        ref
                            .read(productMultiplierChangeProvider.notifier)
                            .postMultiplier(product);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Confirmar"),
                    ),
                  ),
                  error: (_, __) => ElevatedButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        final product = ProductMultiplierModel(
                            codigo: widget.barcode,
                            descricao: '',
                            multiplier: double.parse(controller.text));

                        ref
                            .read(productMultiplierChangeProvider.notifier)
                            .postMultiplier(product);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Confirmar"),
                    ),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                )
                /* ElevatedButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      final product = ProductMultiplierModel(
                          codigo: widget.barcode,
                          descricao: '',
                          multiplier: double.parse(controller.text));

                      ref
                          .read(productMultiplierChangeProvider.notifier)
                          .postMultiplier(product);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Confirmar"),
                  ),
                ), */
              ],
            );
          },
          error: (_, __) => const Center(
            child: Text("Erro ao consultar produto"),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
