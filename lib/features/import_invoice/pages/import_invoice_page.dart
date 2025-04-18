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

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await showBackDialog(context) ?? false;
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text("Import. NF Entrada")),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                provider.when(
                  data: (data) => Text(data.toString()),
                  error: (err, stack) => Text(err.toString()),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                NoKeyboardTextSearchForm(
                  label: 'Pesquisa Chave',
                  autoFocus: true,
                  onSubmitted: (e) {},
                  //validator: isNotEmpty,
                  controller: controller,
                ),
                const Divider(),
                ElevatedButton(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
