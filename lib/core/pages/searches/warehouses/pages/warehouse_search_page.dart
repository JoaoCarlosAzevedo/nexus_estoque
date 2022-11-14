import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/pages/searches/warehouses/cubit/products_search_cubit.dart';
import 'package:nexus_estoque/core/pages/searches/warehouses/cubit/products_search_state.dart';
import 'package:nexus_estoque/core/pages/searches/warehouses/data/repositories/product_search_repository.dart';

class WarehouseSearchPage extends ConsumerStatefulWidget {
  const WarehouseSearchPage({super.key});

  @override
  ConsumerState<WarehouseSearchPage> createState() =>
      _WarehouseSearchPageState();
}

class _WarehouseSearchPageState extends ConsumerState<WarehouseSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Busca Armazem"),
        centerTitle: true,
      ),
      body: BlocProvider<WarehouseSearchCubit>(
        create: (context) =>
            WarehouseSearchCubit(ref.read(warehouseSearchRepository)),
        child: BlocBuilder<WarehouseSearchCubit, WarehouseSearchState>(
          builder: (context, state) {
            if (state is WarehouseSearchLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is WarehouseSearchError) {
              return Center(
                child: Text(state.error.error),
              );
            }

            if (state is WarehouseSearchLoaded) {
              final list = state.warehouses;
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<WarehouseSearchCubit>().fetchWarehouses();
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
                              subtitle: Text(list[index].codigo),
                              trailing: Text(list[index].filial),
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
