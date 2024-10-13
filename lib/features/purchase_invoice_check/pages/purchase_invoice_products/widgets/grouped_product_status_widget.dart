import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/purchase_invoice_model.dart';
import '../../../data/repositories/purchase_invoice_repository.dart';
import '../cubit/purchase_invoice_products_cubit.dart';

class GroupedProductsStatusList extends StatelessWidget {
  const GroupedProductsStatusList({
    super.key,
    required this.invoices,
    required this.repository,
  });

  final List<PurchaseInvoice> invoices;

  final PurchaseInvoiceRepository repository;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0, bottom: 8.0),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: true,
            child: BlocProvider(
                create: (context) =>
                    PurchaseInvoiceProductsCubit(invoices, repository),
                child: BlocBuilder<PurchaseInvoiceProductsCubit,
                    PurchaseInvoiceProductsState>(
                  builder: (context, state) {
                    List<GroupedProds> groupProducts = [];
                    if (state is PurchaseInvoiceProductsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is PurchaseInvoiceProductsLChecking) {
                      final invoices = state.invoices;
                      final products = invoices.fold(<PurchaseInvoiceProduct>[],
                          (previousValue, element) {
                        previousValue.addAll(element.purchaseInvoiceProducts);
                        return previousValue;
                      });

                      for (var product in products) {
                        final index = groupProducts.indexWhere(
                            (e) => e.code.trim() == product.codigo.trim());
                        if (index == -1) {
                          groupProducts.add(GroupedProds(
                              code: product.codigo,
                              description: product.descricao,
                              quantity: product.quantidade,
                              quantityCheck: product.checked,
                              invoices: 1));
                        } else {
                          groupProducts[index].quantity += product.quantidade;
                          groupProducts[index].quantityCheck += product.checked;
                          groupProducts[index].invoices += 1;
                        }
                      }

                      groupProducts = groupProducts
                          .where((element) => element.getStatus())
                          .toList();

                      return groupProducts.isEmpty
                          ? const Center(
                              child: Text('Nenhum registro pendente'),
                            )
                          : Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    keyboardDismissBehavior:
                                        ScrollViewKeyboardDismissBehavior
                                            .onDrag,
                                    itemCount: groupProducts.length,
                                    itemBuilder: (context, index) {
                                      final product = groupProducts[index];
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Card(
                                          shape: Border(
                                            left: BorderSide(
                                                color: product.statusColor(),
                                                width: 5),
                                          ),
                                          child: ListTile(
                                            /*  title: Text(
                                        '(${product.invoices}) ${product.code}', */
                                            title: Text.rich(
                                              TextSpan(
                                                text: '(${product.invoices}) ',
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: <InlineSpan>[
                                                  TextSpan(
                                                    text: product.code,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  )
                                                ],
                                              ),
                                            ),
                                            subtitle: Text(product.description),
                                            trailing: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                const Text("Conferido"),
                                                Text(product.quantityCheck
                                                    .toStringAsFixed(2))
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                    }
                    return const Text("estado invalido");
                  },
                )),
          ),
        ],
      ),
    );
  }
}

class GroupedProds {
  String code;
  String description;
  double quantity;
  double quantityCheck;
  int invoices;

  GroupedProds({
    required this.code,
    required this.description,
    required this.quantity,
    required this.quantityCheck,
    required this.invoices,
  });

  bool getStatus() {
    if (quantityCheck < quantity) {
      return true;
    }
    if (quantityCheck > quantity) {
      return true;
    }
    return false;
  }

  Color statusColor() {
    if (quantityCheck < quantity) {
      return Colors.orange;
    }
    if (quantityCheck > quantity) {
      return Colors.red;
    }
    if (quantity == quantityCheck) {
      return Colors.green;
    }
    return Colors.grey;
  }
}
