import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/produc_transfer_card.dart';

class ProductBalanceDataWidget extends ConsumerWidget {
  const ProductBalanceDataWidget({required this.productBalance, super.key});
  final ProductBalanceModel productBalance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProductHeaderCard(
            productDetail: productBalance,
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: productBalance.armazem.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '${productBalance.armazem[index].codigo} - ${productBalance.armazem[index].descricao}'),
                          Text(
                              '${productBalance.armazem[index].saldoLocal} ${productBalance.uM}'),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: productBalance.armazem[index].enderecos.length,
                      itemBuilder: (context, innerIndex) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: ListTile(
                              title: Text(productBalance
                                  .armazem[index].enderecos[innerIndex].codigo),
                              subtitle: Text(
                                  "Endereço:  ${productBalance.armazem[index].enderecos[innerIndex].descricao}"),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Saldo: ${productBalance.armazem[index].enderecos[innerIndex].quantidade}',
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                  Text(
                                      'Empen.: ${productBalance.armazem[index].enderecos[innerIndex].empenho}'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
