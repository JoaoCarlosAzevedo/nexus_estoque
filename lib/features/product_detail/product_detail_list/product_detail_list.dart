import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/features/searches/products/data/model/product_model.dart';
import '../../../core/features/searches/products/provider/remote_product_provider.dart';

class ProductDetailListPage extends ConsumerStatefulWidget {
  const ProductDetailListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductDetailListPageState();
}

class _ProductDetailListPageState extends ConsumerState<ProductDetailListPage> {
  List<ProductModel> filterListProducts = [];
  List<ProductModel> listProducts = [];
  bool resetFilter = true;

  @override
  Widget build(BuildContext context) {
    final futureProvider = ref.watch(remoteProductProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta de Produtos"),
        actions: [
          IconButton(
              onPressed: () {
                ref.invalidate(remoteProductProvider);
                resetFilter = true;
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: futureProvider.when(
        skipLoadingOnRefresh: false,
        data: (data) {
          listProducts = data;
          if (resetFilter) {
            filterListProducts = data;
            resetFilter = false;
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (e) {
                    productSearch(e);
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    label: Text("Pesquisar Código / Descrição"),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filterListProducts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(top: 10),
                        child: ListTile(
                          onLongPress: () {
                            /*   showProductMultiplierModal(
                                context, filterListProducts[index].codigo); */
                          },
                          onTap: () {
                            context.push(
                                '/saldo_produto/${filterListProducts[index].codigo}');
                          },
                          title: Text(filterListProducts[index].descricao),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(filterListProducts[index].codigo),
                              Text(
                                  'Cód Barras: ${filterListProducts[index].codigoBarras}'),
                              /*         Text(
                                  'Cód Dun: ${filterListProducts[index].codigoBarras2}'),
                              if (filterListProducts[index].fator > 0)
                                Text(
                                    'Fator Dun: ${filterListProducts[index].fator.toStringAsFixed(0)}'), */
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Tipo ${filterListProducts[index].tipo}'),
                                  Text(
                                      'Local ${filterListProducts[index].localPadrao}'),
                                ],
                              ),
                            ],
                          ),
                          trailing: Column(
                            children: [
                              /*     Text(filterListProducts[index]
                                  .saldoAtual
                                  .toString()), */
                              Text(filterListProducts[index].um),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        error: (err, stack) => Center(
          child: Text(err.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void productSearch(String search) {
    if (search.isNotEmpty) {
      setState(() {
        filterListProducts = listProducts.where((element) {
          if (element.codigo.toUpperCase().contains(search.toUpperCase())) {
            return true;
          }

          if (element.codigoBarras.toUpperCase() == (search.toUpperCase())) {
            return true;
          }
          if (element.codigoBarras2.toUpperCase() == (search.toUpperCase())) {
            return true;
          }

          if (element.descricao.toUpperCase().contains(search.toUpperCase())) {
            return true;
          }
          return false;
        }).toList();
      });
    } else {
      setState(() {
        resetFilter = true;
      });
    }
  }
}
