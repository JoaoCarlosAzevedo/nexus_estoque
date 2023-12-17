import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/features/searches/products/data/model/product_model.dart';
import 'package:nexus_estoque/core/features/searches/products/provider/remote_product_provider.dart';

class ProductSearchModal {
  static Future<String> show(BuildContext context, bool? hideBalance) async {
    {
      final result = await showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.9,
            child: ProductSearchPage(
              hideBalance: hideBalance,
            ),
          );
        },
      );

      if (result != null) {
        return result;
      } else {
        return '';
      }
    }
  }
}

class ProductSearchPage extends ConsumerStatefulWidget {
  const ProductSearchPage({this.hideBalance, super.key});
  final bool? hideBalance;

  @override
  ConsumerState<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends ConsumerState<ProductSearchPage> {
  List<ProductModel> filterListProducts = [];
  List<ProductModel> listProducts = [];
  bool resetFilter = true;

  @override
  Widget build(BuildContext context) {
    final futureProvider = ref.watch(remoteProductProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Busca Produtos"),
        centerTitle: true,
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
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) {
            final Failure failure = err as Failure;
            return Center(child: Text(failure.error));
          },
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
                            onTap: () {
                              Navigator.pop(
                                  context, filterListProducts[index].codigo);
                            },
                            title: Text(filterListProducts[index].descricao),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(filterListProducts[index].codigo),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Tipo ${filterListProducts[index].tipo}'),
                                    if (widget.hideBalance ?? false)
                                      Text(
                                          'Local ${filterListProducts[index].localPadrao}'),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Column(
                              children: [
                                if (widget.hideBalance ?? true)
                                  Text(filterListProducts[index]
                                      .saldoAtual
                                      .toString()),
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
          }),
    );
  }

  void productSearch(String search) {
    if (search.isNotEmpty) {
      setState(() {
        filterListProducts = listProducts.where((element) {
          if (element.codigo.toUpperCase().contains(search.toUpperCase())) {
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

/* 
Padding(
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
                                onTap: () {
                                  Navigator.pop(context,
                                      filterListProducts[index].codigo);
                                },
                                title:
                                    Text(filterListProducts[index].descricao),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(filterListProducts[index].codigo),
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
                                    Text(filterListProducts[index]
                                        .saldoAtual
                                        .toString()),
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
                ); */