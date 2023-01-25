import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/searches/products/cubit/products_search_cubit.dart';
import 'package:nexus_estoque/core/features/searches/products/cubit/products_search_state.dart';
import 'package:nexus_estoque/core/features/searches/products/data/model/product_search_model.dart';
import 'package:nexus_estoque/core/features/searches/products/data/repositories/product_search_repository.dart';

class ProductSearchPage extends ConsumerStatefulWidget {
  const ProductSearchPage({super.key});

  @override
  ConsumerState<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends ConsumerState<ProductSearchPage> {
  List<ProductSearchModel> filterListProducts = [];
  List<ProductSearchModel> listProducts = [];
  bool resetFilter = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Busca Produtos"),
        centerTitle: true,
      ),
      body: BlocProvider<ProductsSearchCubit>(
        create: (context) =>
            ProductsSearchCubit(ref.read(productSearchRepository)),
        child: BlocBuilder<ProductsSearchCubit, ProductsSearchState>(
          builder: (context, state) {
            if (state is ProductsSearchLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ProductsSearchError) {
              return Center(
                child: Text(state.error.error),
              );
            }

            if (state is ProductsSearchLoaded) {
              listProducts = state.products;
              if (resetFilter) {
                filterListProducts = state.products;
                resetFilter = false;
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProductsSearchCubit>().cleanCache();
                },
                child: Padding(
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
                ),
              );
            }
            return const Center(
              child: Text("aaa"),
            );
          },
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
