import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../data/model/purchase_invoice_model.dart';
import '../../data/repositories/purchase_invoice_repository.dart';
import '../purchase_invoice_products/purchase_invoice_products_page.dart';

class PurchaseInvoiceListPage extends ConsumerStatefulWidget {
  const PurchaseInvoiceListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PurchaseInvoiceListPageState();
}

class _PurchaseInvoiceListPageState
    extends ConsumerState<PurchaseInvoiceListPage> {
  @override
  Widget build(BuildContext context) {
    final futureProvider = ref.watch(purchaseInvoicesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Veículos x Notas"),
        actions: [
          IconButton(
              onPressed: () {
                ref.invalidate(purchaseInvoicesProvider);
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: futureProvider.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          return Center(child: Text(err.toString()));
        },
        data: (data) {
          if (data.isEmpty) {
            return const Center(
              child: Text("Nenhum registro encontrado."),
            );
          }
          return GroupedListView<PurchaseInvoice, String>(
            elements: data,
            groupBy: (element) =>
                "${element.codVeiculo}/${element.descVeiculo}/${element.placaVeiculo}",
            groupSeparatorBuilder: (String groupByValue) {
              final split = groupByValue.split('/');
              final codVeic = split[0];
              final descveic = split[1];
              final placa = split[2];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      final invoices = data
                          .where(
                              (element) => element.codVeiculo.contains(codVeic))
                          .toList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PurchaseInvoiceProdutcts(
                            invoices: invoices,
                          ),
                        ),
                      );
                    },
                    leading: const FaIcon(FontAwesomeIcons.truck),
                    title: Text(
                      "$codVeic - $placa",
                      overflow: TextOverflow.visible,
                    ),
                    subtitle: Text(descveic),
                    //trailing: const FaIcon(FontAwesomeIcons.magnifyingGlass),
                  ),
                ),
              );
            },
            itemBuilder: (context, PurchaseInvoice element) {
              return const Visibility(
                visible: false,
                child: Text(""),
              );
              /*  return Card(
                child: ListTile(
                  onTap: () {},
                  title: Text("${element.nomeCliente}}"),
                  subtitle: Text(
                      "NF ${element.notaFiscal} - Itens ${element.purchaseInvoiceProducts.length}"),
                ),
              ); */
            },
            useStickyGroupSeparators: true, // optional
            floatingHeader: true, // optional
            order: GroupedListOrder.ASC, // optional
          );
        },
      ),
    );
  }
}
