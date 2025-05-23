import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';
import 'package:nexus_estoque/features/address/data/model/product_address_model.dart';

class ProductInfo extends StatelessWidget {
  const ProductInfo({super.key, required this.productAddress});
  final ProductAddressModel productAddress;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //color: Theme.of(context).selectedRowColor,
        //borderRadius: BorderRadius.circular(15),
        color: AppColors.background,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: FaIcon(FontAwesomeIcons.boxOpen),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productAddress.descricao,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Codigo",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      productAddress.codigo,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Fornecedor",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          productAddress.fornecedor,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Armazem",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      productAddress.armazem,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "NF",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${productAddress.notafiscal} ${productAddress.serie}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      "Data",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      productAddress.data,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Saldo a endereçar",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      "${productAddress.saldo} ${productAddress.um}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (productAddress.lote.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("Lote: ${productAddress.lote}"),
              ),
          ],
        ),
      ),
    );
  }
}
