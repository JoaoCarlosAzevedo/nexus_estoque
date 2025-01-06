import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/features/searches/products/data/model/product_model.dart';
import '../../../core/features/searches/products/provider/remote_product_provider.dart';

class ProductTagListPage extends ConsumerStatefulWidget {
  const ProductTagListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductTagListPageState();
}

class _ProductTagListPageState extends ConsumerState<ProductTagListPage> {
  List<ProductModel> filterListProducts = [];
  List<ProductModel> listProducts = [];
  bool resetFilter = true;

  @override
  Widget build(BuildContext context) {
    final futureProvider = ref.watch(remoteProductProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta Produto"),
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
                          onTap: () {
                            context.push(
                              '/etiqueta_produto/${filterListProducts[index].codigo}',
                            );
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
