import 'package:flutter/material.dart';
import 'package:nexus_estoque/features/outflow_doc_check/pages/outflow_doc_page/widgets/progress_indicator_widget.dart';

import '../../../data/model/purchase_invoice_model.dart';

class InvoiceProductCheckCard extends StatelessWidget {
  const InvoiceProductCheckCard(
      {super.key,
      required this.product,
      required this.onTapCard,
      required this.onDelete});
  final PurchaseInvoiceProduct product;
  final Function()? onTapCard;
  final Function()? onDelete;

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
                  /* Expanded(
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
                  ), */
                ],
              ),
              if (product.checked > product.quantidade)
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
