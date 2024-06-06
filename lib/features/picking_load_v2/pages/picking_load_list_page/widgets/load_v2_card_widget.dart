import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/shippingv2_model.dart';

class Loadv2CardWidget extends ConsumerWidget {
  const Loadv2CardWidget(
      {required this.load,
      required this.onTap,
      required this.onSearch,
      super.key});
  final Shippingv2Model load;
  final void Function()? onTap;
  final void Function()? onSearch;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Carga ${load.codCarga}",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            IconButton(onPressed: onSearch, icon: const Icon(Icons.search))
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (load.isFaturado()) const Text("Status: Faturado"),
              if (load.descRota.isNotEmpty) Text("Rota: ${load.descRota}"),
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
                          "Transportadora",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          load.descTransp,
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
                          "Qtd. Entregas",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          "${load.qtdEntregas}",
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
                          "Peso Carga",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${load.peso}",
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
                          "Qtd. Pedidos",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          "${load.pedidos.length}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        )
                      ],
                    ),
                  ), */
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
