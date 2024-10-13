import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/outflow_doc_check/data/model/outflow_doc_model.dart';
import 'package:nexus_estoque/features/outflow_doc_check/pages/outflow_doc_page/cubit/outflow_doc_cubit.dart';
import 'package:nexus_estoque/features/outflow_doc_check/pages/outflow_doc_page/widgets/barcode_scanned_widget.dart';
import 'package:nexus_estoque/features/outflow_doc_check/pages/outflow_doc_page/widgets/product_card_widget.dart';
import 'package:nexus_estoque/features/outflow_doc_check/pages/outflow_doc_page/widgets/quantity_modal_wiget.dart';

import '../../../../../core/widgets/form_input_no_keyboard_widget.dart';

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
  final GroupedProducts? scannedProduct;
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
    final cubit = context.read<OutFlowDocCubit>();
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: true,
          child: Column(
            children: [
              if (document.isCompleted())
                Text(
                  "Documento já conferido!",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              if (!document.isCompleted())
                NoKeyboardTextForm(
                  autoFocus: true,
                  focusNode: focus,
                  controller: controller,
                  label: "Cód. Barras ou SKU...",
                  onSubmitted: (value) {
                    widget.onSubmitted!(value);
                    focus.requestFocus();
                    controller.clear();
                  },
                ),
              /*  TextField(
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
                  })), */
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
                      onTapCard: () async {
                        if (product.um.trim() == "L") {
                          double? newQuantity = await CheckQuantityModal.show(
                              context, product, product.checked);
                          if (newQuantity != null) {
                            cubit.setProductCheck(index, newQuantity);
                          }
                        }
                      },
                      onDelete: () {
                        cubit.setProductCheck(index, 0);
                      },
                    );
                  },
                ),
              ),
              if (!document.isCompleted())
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
