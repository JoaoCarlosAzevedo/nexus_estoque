import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/back_buttom_dialog.dart';
import '../../../core/widgets/form_input_no_keyboard_search_widget.dart';
import '../provider/import_invoice_provider.dart';

class ImportInvoicePage extends ConsumerStatefulWidget {
  const ImportInvoicePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ImportInvoicePageState();
}

class _ImportInvoicePageState extends ConsumerState<ImportInvoicePage> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final provider = ref.watch(importInvoiceProvider);

    ref.listen(importInvoiceProvider, (previous, current) {
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Import. NF Entrada")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              NoKeyboardTextSearchForm(
                label: 'Pesquisa Chave',
                autoFocus: true,
                onSubmitted: (e) {
                  ref
                      .read(importInvoiceProvider.notifier)
                      .fetchImportInvoice(e);
                },
                controller: controller,
              ),
              const Divider(),
              Center(
                child: provider.when(
                  data: (data) {
                    if (data) {
                      return const Text(
                        "NF Importada com sucesso!",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                        ),
                      );
                    }
                    return Container();
                  },
                  error: (err, stack) => const Text(
                    "Erro a importar NF, tente novamente!",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              /*   ElevatedButton(
                onPressed: () {
                  ref
                      .read(importInvoiceProvider.notifier)
                      .fetchImportInvoice(controller.text);
                },
                child: SizedBox(
                  height: height / 15,
                  width: double.infinity,
                  child: const Center(child: Text("Confirmar")),
                ),
              ), */
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ElevatedButton(
          onPressed: () {
            ref
                .read(importInvoiceProvider.notifier)
                .fetchImportInvoice(controller.text);
          },
          child: SizedBox(
            height: height / 15,
            width: double.infinity,
            child: const Center(child: Text("Confirmar")),
          ),
        ),
      ),
    );
  }
}
