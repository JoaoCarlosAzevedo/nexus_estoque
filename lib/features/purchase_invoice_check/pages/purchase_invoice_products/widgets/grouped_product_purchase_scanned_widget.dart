import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';

import '../../../data/model/purchase_invoice_model.dart';

// ignore: must_be_immutable
class GroupedProductScannedCard extends StatelessWidget {
  GroupedProductScannedCard(
      {super.key,
      required this.product,
      required this.barcode,
      required this.listInvoices,
      required this.notFound,
      required this.onPressed,
      required this.onClose});

  final PurchaseInvoiceProduct? product;
  final List<PurchaseInvoice> listInvoices;
  final String? barcode;
  final bool notFound;
  final void Function()? onClose;
  final void Function()? onPressed;

  double checked = 0;
  double quantityOriginal = 0;
  bool showQtd = false;

  @override
  Widget build(BuildContext context) {
    getChecked();

    return product != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                child: Text(
                  "Produto Coletado",
                ),
              ),
              Stack(
                children: [
                  Card(
                    elevation: 6.0,
                    color: isAvisoInferior()
                        ? Colors.orangeAccent
                        : isAvisoSuperior()
                            ? Colors.red
                            : Colors.grey,
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                          right: (isAvisoInferior() || isAvisoSuperior())
                              ? 10
                              : 0),
                      child: ListTile(
                        title: Text(
                          "${product?.item} ${product?.descricao}",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Cód. Barras: ${(barcode ?? "") == "avisoAbaixo" ? '' : barcode}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "SKU: ${product!.codigo}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Conferido: $checked",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ],
                            ),
                            if (isAvisoInferior())
                              Text(
                                "Conferência com pendencias",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(color: Colors.orange),
                              ),
                            if (checked > quantityOriginal)
                              if (showQtd)
                                Text(
                                  "Total Itens da NF: $quantityOriginal",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(color: Colors.red),
                                ),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: onPressed,
                          icon: const FaIcon(FontAwesomeIcons.penToSquare),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      onTap: onClose,
                      child: const Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 12.0,
                          backgroundColor: AppColors.primary,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
            ],
          )
        : notFound
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: .0, left: 5.0, right: 5.0),
                    child: Text(
                      "Produto Coletado",
                    ),
                  ),
                  Stack(children: [
                    Card(
                      child: ListTile(
                        title: const Text("Produto não encontrado!"),
                        subtitle: Text("Cód. Barras: ${barcode ?? ""}"),
                        trailing: const FaIcon(
                          FontAwesomeIcons.fileCircleXmark,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: onClose,
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 12.0,
                            backgroundColor: AppColors.primary,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  const Divider()
                ],
              )
            : Container();
  }

  bool isAvisoInferior() {
    if (barcode != null) {
      if (barcode == 'avisoAbaixo') {
        return true;
      }
    }
    return false;
  }

  bool isAvisoSuperior() {
    if (checked > quantityOriginal) {
      return true;
    }
    return false;
  }

  void getChecked() {
    showQtd = listInvoices.first.showQtd;

    if (product != null) {
      final allProducts = listInvoices.fold(<PurchaseInvoiceProduct>[],
          (previousValue, element) {
        previousValue.addAll(element.purchaseInvoiceProducts);
        return previousValue;
      });

      final products = allProducts
          .where((element) => element.codigo.trim() == product!.codigo.trim())
          .toList();

      checked = products.fold(0, (sum, element) => sum + element.checked);
      quantityOriginal =
          products.fold(0, (sum, element) => sum + element.quantidade);
    }
  }
}
