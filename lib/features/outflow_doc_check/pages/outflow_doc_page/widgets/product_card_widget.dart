import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nexus_estoque/features/outflow_doc_check/data/model/outflow_doc_model.dart';
import 'package:nexus_estoque/features/outflow_doc_check/pages/outflow_doc_page/widgets/progress_indicator_widget.dart';

import '../../../../../core/features/product_multiplier/pages/product_multiplier_modal.dart';

class ProductCheckCard extends StatelessWidget {
  const ProductCheckCard(
      {super.key,
      required this.product,
      required this.onTapCard,
      required this.onDelete,
      required this.onChangeProduct});
  final Produtos product;
  final Function()? onTapCard;
  final Function()? onDelete;
  final Function()? onChangeProduct;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: onTapCard,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  "${product.item} ${product.descricao}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              IconButton(
                onPressed: () async {
                  final newValue =
                      await showProductMultiplierModal(context, product.codigo);

                  if (newValue > 0) {
                    // ignore: use_build_context_synchronously
                    //Navigator.pop(context);
                    product.fator = newValue;

                    onChangeProduct?.call();
                  }
                },
                icon: const Icon(Icons.calculate),
                color: Colors.green,
              ),
              if (product.checked > product.quantidade)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_forever),
                  color: Colors.red,
                )
            ],
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cód Barras",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          product.barcode,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        )
                      ],
                    ),
                  ),
                  if (!product.isBlind)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Quantidade",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            "${product.quantidade} ${product.um}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        ],
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cód Prod.",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.codigo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Conferido",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          "${product.checked} ${product.um}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              ProgressIndicatorWidget(
                value: product.checked / product.quantidade,
              ),
            ],
          ),
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}
