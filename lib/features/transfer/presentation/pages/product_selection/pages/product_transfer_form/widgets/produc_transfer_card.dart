import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';

import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/data/model/product_balance_model.dart';

class ProductTransferCard extends StatelessWidget {
  final ProductBalanceModel productDetail;
  const ProductTransferCard({
    Key? key,
    required this.productDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: height / 5,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.00),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: FaIcon(FontAwesomeIcons.boxOpen),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productDetail.descricao,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Código: ${productDetail.codigo}",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            //const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  productDetail.codigoBarras,
                  style: Theme.of(context).textTheme.caption,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 10),
                  child: Text(
                    "${productDetail.stock} ${productDetail.uM}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}