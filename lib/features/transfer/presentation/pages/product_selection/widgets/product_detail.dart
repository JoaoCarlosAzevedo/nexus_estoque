import 'package:flutter/material.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/data/model/product_balance_model.dart';

class ProductSelectedDetail extends StatefulWidget {
  final ProductBalanceModel productDetail;

  const ProductSelectedDetail({super.key, required this.productDetail});

  @override
  State<ProductSelectedDetail> createState() => _ProductSelectedDetailState();
}

class _ProductSelectedDetailState extends State<ProductSelectedDetail> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 14,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("Item: ${index}"),
                  );
                }),
          ),
          Expanded(
            flex: 3,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 14,
                itemBuilder: (context, index) {
                  return Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("Item: ${index}"),
                  );
                }),
          ),
          ElevatedButton(
            onPressed: () {},
            child: SizedBox(
              width: double.infinity,
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Center(child: Text("Confirmar")),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
