import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/theme/theme.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/data/model/product_balance_model.dart';

class ProductSelectedDetail extends StatefulWidget {
  final ProductBalanceModel productDetail;

  const ProductSelectedDetail({super.key, required this.productDetail});

  @override
  State<ProductSelectedDetail> createState() => _ProductSelectedDetailState();
}

class _ProductSelectedDetailState extends State<ProductSelectedDetail> {
  static const List<String> _kOptions = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];

  @override
  Widget build(BuildContext context) {
    //final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          //height: height / 5,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).secondaryHeaderColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productDetail.descricao,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Divider(),
                Text("Código: ${widget.productDetail.codigo}"),
                const Divider(),
                Row(
                  children: [
                    const Icon(Icons.qr_code),
                    const SizedBox(width: 15),
                    Text(widget.productDetail.codigoBarras),
                  ],
                ),
                const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16, bottom: 16),
                    child: Text(
                      "12312 cx",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Origem",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            return _kOptions.where((String option) {
              return option.contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) {
            debugPrint('You just selected $selection');
          },
        ),
        TextField(
          enabled: true,
          autofocus: false,
          onSubmitted: (e) {
            print("onSubmitted: $e");
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.qr_code),
            suffixIcon: IconButton(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
            ),
            //icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
            label: const Text("Local"),
          ),
        ),
        const Divider(),
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Destino",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Center(child: Text("Confirmar")),
            ),
          ),
        ),
      ],
    );
  }
}
