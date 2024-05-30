import 'package:flutter/material.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';

import '../../../data/model/filter_tag_load_model.dart';

class FilterTagProductCard extends StatelessWidget {
  final InvoiceProduct data;
  final GestureTapCallback onTap;

  const FilterTagProductCard({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              onTap: onTap,
              title: Text(
                data.descricao,
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Codigo: ${data.codigo}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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
                              "Qtd. Emabalado",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              data.quantidaetiqueta.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Qtd. NF / Etiqueta",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            RichText(
                              text: TextSpan(
                                text: "${data.quantidade} ",
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .copyWith(
                                        color: Colors.green, fontSize: 16),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "/ ${data.novaQuantidade} ",
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .copyWith(
                                            color: AppColors.secondaryGrey,
                                            fontSize: 24),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}
