import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/volume_label/pages/order_products_selection_page/widgets/volume_order_quantity.dart';

import '../../../../../core/widgets/form_input_no_keyboard_widget.dart';

import '../../../data/model/volume_order_model.dart';
import '../provider/volume_order_provider.dart';
import 'volume_order_product_card.dart';

class VolumeOrderTab1 extends ConsumerStatefulWidget {
  const VolumeOrderTab1({super.key, required this.orderProds});

  final List<VolumeProdOrderModel> orderProds;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VolumeOrderTab1State();
}

class _VolumeOrderTab1State extends ConsumerState<VolumeOrderTab1> {
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
    final products = widget.orderProds;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: NoKeyboardTextForm(
              autoFocus: true,
              focusNode: focus,
              controller: controller,
              label: "Cód. Barras ou SKU...",
              onSubmitted: (value) {
                //context.read<FilterTagLoadOrderCubit>().addProduct(value);
                ref.read(volumeOrderProvider.notifier).checkBarcode(value);
                focus.requestFocus();
                controller.clear();
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: VolumeOrderProductCard(
                      onTap: () async {
                        double? newQuantity =
                            await VolumeOrderQuantityModal.show(context,
                                products[index], products[index].novaQtd);
                        if (newQuantity != null) {
                          ref.read(volumeOrderProvider.notifier).changeQuantity(
                              products[index].codigo, newQuantity);
                          // ignore: use_build_context_synchronously
                          /* context.read<FilterTagLoadCubit>().selectProduct(
                              products[index].codigo, newQuantity, 0); */
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
