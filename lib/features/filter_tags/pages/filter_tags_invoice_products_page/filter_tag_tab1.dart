import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/filter_tags/pages/filter_tags_invoice_products_page/widgets/tag_product_quantity_modal.dart';

import '../../../../core/widgets/form_input_no_keyboard_widget.dart';
import '../../data/model/filter_tag_load_model.dart';
import '../filter_tags_load_page/cubit/filter_tag_load_cubit.dart';
import 'widgets/filter_tag_product_card.dart';

class FilterTagTab1 extends ConsumerStatefulWidget {
  const FilterTagTab1({super.key, required this.invoice});
  final Invoice invoice;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FilterTagTab1State();
}

class _FilterTagTab1State extends ConsumerState<FilterTagTab1> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focus = FocusNode();

  @override
  void dispose() {
    focus.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = widget.invoice.itens;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
              "Nota Fiscal: ${widget.invoice.notaFiscal}/${widget.invoice.serie}"),
          Text("Cliente: ${widget.invoice.nomeCliente}"),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: NoKeyboardTextForm(
              autoFocus: true,
              focusNode: focus,
              controller: controller,
              label: "Cód. Barras ou SKU...",
              onSubmitted: (value) {
                context.read<FilterTagLoadCubit>().addProduct(value);
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
                context.read<FilterTagLoadCubit>().addProduct(value);
                focus.requestFocus();
                controller.clear(); 
              }),
            ), */
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilterTagProductCard(
                      onTap: () async {
                        double? newQuantity =
                            await PurchaseFilterTagProductQuantityModal.show(
                                context,
                                products[index],
                                products[index].novaQuantidade);
                        if (newQuantity != null) {
                          // ignore: use_build_context_synchronously
                          context.read<FilterTagLoadCubit>().selectProduct(
                              products[index].codigo, newQuantity, 0);
                        }
                      },
                      data: products[index],
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
