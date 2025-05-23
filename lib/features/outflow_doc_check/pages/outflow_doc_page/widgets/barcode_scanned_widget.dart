import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';
import 'package:nexus_estoque/features/outflow_doc_check/data/model/outflow_doc_model.dart';
import 'package:nexus_estoque/features/outflow_doc_check/pages/outflow_doc_page/widgets/progress_chart_widget.dart';

class BarcodeScannedCard extends StatelessWidget {
  const BarcodeScannedCard(
      {super.key,
      required this.product,
      required this.barcode,
      required this.notFound,
      required this.onClose});
  final GroupedProducts? product;
  final String? barcode;
  final bool notFound;
  final void Function()? onClose;

  @override
  Widget build(BuildContext context) {
    /* if (notFound) {
      AudioService.error();
    }

    if (product != null) {
      AudioService.beep();
    } */

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
                        "${product?.descricao}",
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
                            "SKU: ${product!.produto}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              /*     Text(
                                "Conferido: ${product!.getTotalConferido()} / ${product!.getTotalNF()}",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ), */
                              RichText(
                                text: TextSpan(
                                  text:
                                      "Conferido: ${product!.getTotalConferido()} / ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${product!.getTotalNF()}',
                                        style: const TextStyle(
                                            color: Colors.green)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 30,
                              height: 30,
                              child: ProgressChart(
                                  value: product!.getTotalConferido() /
                                      product!.getTotalNF())),
                        ],
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
