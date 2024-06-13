import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/filter_tags_orders/pages/filter_tags_order_products_page/widgets/tag_product_order_quantity_modal.dart';

import '../../../../core/widgets/form_input_no_keyboard_widget.dart';
import '../../data/model/filter_tag_load_order_model.dart';
import '../filter_tags_order_load_page/cubit/filter_tag_order_load_cubit.dart';
import 'widgets/filter_tag_product_card.dart';

class FilterTagOrderTab1 extends ConsumerStatefulWidget {
  const FilterTagOrderTab1({super.key, required this.order});
  final Orders order;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FilterTagOrderTab1State();
}

class _FilterTagOrderTab1State extends ConsumerState<FilterTagOrderTab1> {
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
    final products = widget.order.itens;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text("Pedido: ${widget.order.pedido}"),
          Text("Cliente: ${widget.order.nomeCliente}"),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: NoKeyboardTextForm(
              autoFocus: true,
              focusNode: focus,
              controller: controller,
              label: "Cód. Barras ou SKU...",
              onSubmitted: (value) {
                context.read<FilterTagLoadOrderCubit>().addProduct(value);
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
                            await PurchaseFilterTagProductOrderQuantityModal
                                .show(context, products[index],
                                    products[index].novaQuantidade);
                        if (newQuantity != null) {
                          // ignore: use_build_context_synchronously
                          context.read<FilterTagLoadOrderCubit>().selectProduct(
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
