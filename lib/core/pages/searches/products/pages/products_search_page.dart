import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_estoque/core/pages/searches/products/cubit/products_search_cubit.dart';
import 'package:nexus_estoque/core/pages/searches/products/cubit/products_search_state.dart';
import 'package:nexus_estoque/core/pages/searches/products/data/repositories/product_search_repository.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Busca Produtos"),
        centerTitle: true,
      ),
      body: BlocProvider<ProductsSearchCubit>(
        create: (context) => ProductsSearchCubit(ProductSearchRepository()),
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
              final list = state.products;
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProductsSearchCubit>().fetchProducts();
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(list[index].descricao),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(list[index].codigo),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Tipo ${list[index].tipo}'),
                                      Text('Local ${list[index].localPadrao}'),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Column(
                                children: [
                                  Text(list[index].saldoAtual.toString()),
                                  Text(list[index].um),
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
            }
            return const Center(
              child: Text("aaa"),
            );
          },
        ),
      ),
    );
  }
}
