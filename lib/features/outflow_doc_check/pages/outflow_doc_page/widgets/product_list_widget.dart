import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/outflow_doc_check/data/model/outflow_doc_model.dart';

class OutFlowDocProductList extends ConsumerStatefulWidget {
  const OutFlowDocProductList(
      {this.onSubmitted,
      required this.document,
      required this.scannedProduct,
      required this.onSave,
      required this.notFound,
      super.key});
  final Function(String)? onSubmitted;
  final void Function()? onSave;
  final OutFlowDoc document;
  final Produtos? scannedProduct;
  final bool notFound;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OutFlowDocProductListState();
}

class _OutFlowDocProductListState extends ConsumerState<OutFlowDocProductList> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focus = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final document = widget.document;
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: true,
          child: Column(
            children: [
              TextField(
                  autofocus: true,
                  focusNode: focus,
                  controller: controller,
                  decoration: const InputDecoration(
                    label: Text("Cód. Barras ou SKU..."),
                  ),
                  onSubmitted: ((value) {
                    widget.onSubmitted!(value);
                    focus.requestFocus();
                    controller.clear();
                  })),
              if (widget.notFound)
                const Text("Codigo ou Produto nao esta na NF"),
              if (widget.scannedProduct != null)
                Column(
                  children: [
                    Text("Produto Lido: ${widget.scannedProduct?.descricao}"),
                    Text(
                        "Quantidade Conferida: ${widget.scannedProduct?.checked}"),
                  ],
                ),
              Expanded(
                child: ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: document.produtos.length,
                  itemBuilder: (context, index) {
                    final products = document.produtos[index];
                    return Card(
                      child: ListTile(
                        tileColor: Colors.white,
                        title: Text("NF: ${products.descricao}"),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Qtd Prods: ${products.quantidade}"),
                            Text("Qtd Check: ${products.checked}"),
                          ],
                        ),
                        subtitle: Text("Cliente: ${products.codigo}"),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: widget.onSave,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(
                    child: Text("Salvar"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
