import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';

import '../../../data/model/purchase_invoice_model.dart';

class PurchaseScannedCard extends StatelessWidget {
  const PurchaseScannedCard(
      {super.key,
      required this.product,
      required this.barcode,
      required this.notFound,
      required this.onPressed,
      required this.onClose});
  final PurchaseInvoiceProduct? product;
  final String? barcode;
  final bool notFound;
  final void Function()? onClose;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
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
                            "Cód. Barras: ${barcode ?? ""}",
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
                                "Conferido: ${product!.checked}",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                          if (product!.checked > product!.quantidade)
                            Text(
                              "ATENÇÃO - Total NF: ${product!.quantidade}",
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
}

/* 
       if (notFound)
          Column(
            children: [
              const Text("Codigo ou Produto nao esta na NF"),
              Text("Código Escaneado: $barcode")
            ],
          ),
          
 */
