import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../address_balance/data/model/address_balance_model.dart';

class AddressWarehouseCard extends ConsumerWidget {
  const AddressWarehouseCard({super.key, required this.address});
  final AddressBalanceModel address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Endereço',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '${address.codEndereco} - ${address.endereDesc}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
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
                          "Armazém",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '${address.armazem} - ${address.armazemDesc}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              /*
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
                          "Endereço",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '${address.codEndereco} - ${address.endereDesc}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        )
                      ],
                    ),
                  ),
                ],
              ), */
            ],
          ),
        ),
      ),
    );
  }
}
