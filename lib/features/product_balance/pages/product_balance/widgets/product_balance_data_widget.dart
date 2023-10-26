import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/features/searches/addresses/data/model/address_model.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/produc_transfer_card.dart';

class ProductBalanceDataWidget extends ConsumerWidget {
  const ProductBalanceDataWidget({required this.productBalance, super.key});
  final ProductBalanceModel productBalance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = getAllAdresses();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProductHeaderCard(
            productDetail: productBalance,
          ),
        ),
        Expanded(
          child: GroupedListView<AddressModel, String>(
            elements: list,
            useStickyGroupSeparators: true, // optional
            //floatingHeader: true, // optional
            order: GroupedListOrder.ASC,
            itemComparator: (item1, item2) =>
                item1.local.compareTo(item2.local), // optional
            groupBy: (element) => element.local,
            groupSeparatorBuilder: (String groupByValue) {
              final warehouse = productBalance.armazem.firstWhere(
                (element) => element.codigo.contains(groupByValue),
              );

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: FaIcon(FontAwesomeIcons.warehouse),
                          ),
                          Text('${warehouse.codigo} - ${warehouse.descricao}'),
                        ],
                      ),
                      Text('${warehouse.saldoLocal} ${productBalance.uM}'),
                    ],
                  ),
                ),
              );
            },
            itemBuilder: (context, AddressModel element) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Card(
                  child: ListTile(
                    title: Text(element.codigo),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Endereço:  ${element.descricao}"),
                        Text(element.ultimoMov),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Saldo: ${element.quantidade}',
                          style: const TextStyle(color: Colors.green),
                        ),
                        Text('Empen.: ${element.empenho}'),
                      ],
                    ),
                  ),
                ),
              );
            },
            // optional
          ),
        ),
      ],
    );
  }

  List<AddressModel> getAllAdresses() {
    List<AddressModel> addresses = [];

    for (var elements in productBalance.armazem) {
      addresses.addAll(elements.enderecos);
    }

    return addresses;
  }
}
