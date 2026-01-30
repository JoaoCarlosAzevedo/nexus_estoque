import 'package:flutter/material.dart';

import '../../../data/model/pickingv2_model.dart';

class PickingProductCardv2 extends StatelessWidget {
  final Pickingv2Model data;
  final GestureTapCallback onTap;

  const PickingProductCardv2({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: RichText(
                text: TextSpan(
                  text: 'Prédio ${data.predio} - ',
                  style: DefaultTextStyle.of(context)
                      .style
                      .copyWith(color: Colors.orange),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Nível ${data.nivel} - ',
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(color: Colors.green),
                    ),
                    TextSpan(
                      text: 'Apto. ${data.apartamento}',
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              onTap: onTap,
              title: data.lSKUonly
                  ? const Text(" - ")
                  : Text(
                      '${data.itemPedido} - ${data.descricao}',
                    ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Status: ${data.status}",
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
                              "Codigo",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              data.codigo,
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
                              "Quantidade",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              "${data.quantidade}",
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
                              "Endereço",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.descEndereco2,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                if (data.lote.trim().isNotEmpty)
                                  Text(
                                    "Lote: ${data.lote}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
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
                              "Separado",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              data.separado.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            )
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
