import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/features/searches/products/data/model/product_model.dart';
import '../../../../core/features/searches/products/provider/remote_product_provider.dart';
import '../../../../core/mixins/validation_mixin.dart';
import '../../../address_balance/data/model/address_balance_model.dart';
import 'widgets/address_warehouse_card.dart';

class AddressInventoryFormPage extends ConsumerStatefulWidget {
  const AddressInventoryFormPage({required this.address, super.key});
  final AddressBalanceModel address;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressInventoryFormPageState();
}

class _AddressInventoryFormPageState
    extends ConsumerState<AddressInventoryFormPage> with ValidationMixi {
  final TextEditingController productController = TextEditingController();
  final DateFormat formatter = DateFormat('yyyyMMdd');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contagem Produtos"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddressWarehouseCard(
              address: widget.address,
            ),
            const Divider(),
            Text("Documento: " + formatter.format(DateTime.now())),
            const Divider(),
            TextFormField(
              autofocus: true,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (e) {
                getProduct(e);
                productController.clear();
              },
              validator: isNotEmpty,
              controller: productController,
              decoration: const InputDecoration(
                label: Text("Produto"),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.qr_code),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getProduct(String product) {
    //45160894
    final List<ProductModel> listWatch =
        ref.watch(remoteProductProvider).maybeWhen(
              data: (data) => data,
              orElse: () => [],
            );
    if (listWatch.isNotEmpty) {
      final selectedProduct = listWatch
          .firstWhere((element) => element.codigo.trim() == product.trim());
      print('${selectedProduct.descricao}');
    }
  }
}
