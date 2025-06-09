import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/product_balance/data/repositories/product_balance_repository.dart';

import 'widgets/reposition_product_address_lists_widget.dart';

class RepositionV2AddressListPage extends ConsumerStatefulWidget {
  const RepositionV2AddressListPage({required this.productCode, super.key});
  final String productCode;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RepositionV2AddressListPageState();
}

class _RepositionV2AddressListPageState
    extends ConsumerState<RepositionV2AddressListPage> {
  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(productBalancetProvider(widget.productCode));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta Produto"),
      ),
      body: repository.when(
        data: (data) => RepositionProductAddressList(
          productBalance: data,
        ),
        error: (err, stack) => Center(
          child: Text(err.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
