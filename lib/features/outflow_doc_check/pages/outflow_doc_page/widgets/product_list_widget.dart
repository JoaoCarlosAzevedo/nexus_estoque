import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/outflow_doc_check/data/model/outflow_doc_model.dart';
import 'package:nexus_estoque/features/outflow_doc_check/pages/outflow_doc_page/widgets/barcode_scanned_widget.dart';
import 'package:nexus_estoque/features/outflow_doc_check/pages/outflow_doc_page/widgets/product_card_widget.dart';

import '../cubit/outflow_doc_cubit.dart';

class OutFlowDocProductList extends ConsumerStatefulWidget {
  const OutFlowDocProductList(
      {this.onSubmitted,
      required this.document,
      required this.scannedProduct,
      required this.onSave,
      required this.notFound,
      required this.barcodeScanned,
      required this.onClose,
      required this.onTapCard,
      super.key});
  final Function(String)? onSubmitted;
  final void Function()? onSave;
  final OutFlowDoc document;
  final Produtos? scannedProduct;
  final bool notFound;
  final String? barcodeScanned;
  final void Function()? onClose;
  final void Function()? onTapCard;

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
              BarcodeScannedCard(
                barcode: widget.barcodeScanned,
                notFound: widget.notFound,
                product: widget.scannedProduct,
                onClose: widget.onClose,
              ),
              Expanded(
                child: ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: document.produtos.length,
                  itemBuilder: (context, index) {
                    final product = document.produtos[index];
                    return ProductCheckCard(
                      product: product,
                      onTapCard: () {
                        context
                            .read<OutFlowDocCubit>()
                            .resetProductCheck(index);
                      },
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
