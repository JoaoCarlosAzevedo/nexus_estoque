import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/features/product_balance/pages/product_selection/cubit/product_balance_cubit.dart';
import 'package:nexus_estoque/core/features/searches/products/pages/products_search_page.dart';

import '../../../../../../features/reposition/data/model/reposition_transfer_moderl.dart';

class ProductSelectioForm extends StatefulWidget {
  const ProductSelectioForm(
      {super.key, required this.title, required this.icon, this.param});
  final String title;
  final IconData icon;
  final dynamic param;

  @override
  State<ProductSelectioForm> createState() => _ProductSelectioFormState();
}

class _ProductSelectioFormState extends State<ProductSelectioForm> {
  final TextEditingController controller = TextEditingController();

  void productSearchPage() async {
    final String? result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const FractionallySizedBox(
          heightFactor: 0.9,
          child: ProductSearchPage(),
        );
      },
    );
    if (result != null) {
      controller.text = result;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: height / 15, bottom: height / 15),
              child: SizedBox(
                height: height / 10,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: FaIcon(
                    widget.icon,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: true,
                    autofocus: true,
                    controller: controller,
                    onSubmitted: (e) {
                      if (controller.text.isNotEmpty) {
                        context
                            .read<ProductBalanceCubit>()
                            .fetchProductBalance(controller.text);
                        controller.clear();
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.qr_code),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          //productSearchPage();
                          controller.text =
                              await ProductSearchModal.show(context, null);
                        },
                        icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
                      ),
                      label: const Text("Código de Barras"),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height / 20,
            ),
            ElevatedButton(
              onPressed: () {
                final reposition = widget.param != null
                    ? widget.param as RepositionTrasnferModel
                    : null;
                if (controller.text.isNotEmpty) {
                  if (reposition == null) {
                    context
                        .read<ProductBalanceCubit>()
                        .fetchProductBalance(controller.text);
                    controller.clear();
                    return;
                  }

                  if ((reposition.product.trim() == controller.text.trim())) {
                    context
                        .read<ProductBalanceCubit>()
                        .fetchProductBalance(controller.text);
                    controller.clear();
                  } else {
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            desc:
                                "Produto informado não é o mesmo da reposição escolhida.",
                            btnOkOnPress: () {},
                            btnOkColor: Theme.of(context).primaryColor)
                        .show();
                  }
                }
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
    );
  }
}
