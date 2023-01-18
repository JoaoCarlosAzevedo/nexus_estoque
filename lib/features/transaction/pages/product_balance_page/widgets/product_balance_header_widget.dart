import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/data/model/product_balance_model.dart';

class ProductBalanceHeader extends StatelessWidget {
  const ProductBalanceHeader({super.key, required this.productBalance});
  final ProductBalanceModel productBalance;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: FaIcon(FontAwesomeIcons.boxOpen),
                ),
                Flexible(
                  child: Text(
                    productBalance.descricao,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Código: ${productBalance.codigo}",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  "Tipo: ${productBalance.tipo}",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            //const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  productBalance.codigoBarras,
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(
                  productBalance.localPadrao,
                  style: Theme.of(context).textTheme.caption,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 10),
                  child: Text(
                    "${productBalance.stock} ${productBalance.uM}",
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
