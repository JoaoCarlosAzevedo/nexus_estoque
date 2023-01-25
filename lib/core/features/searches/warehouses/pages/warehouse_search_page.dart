import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/features/searches/warehouses/cubit/products_search_cubit.dart';
import 'package:nexus_estoque/core/features/searches/warehouses/cubit/products_search_state.dart';
import 'package:nexus_estoque/core/features/searches/warehouses/data/model/warehouse_search_model.dart';
import 'package:nexus_estoque/core/features/searches/warehouses/data/repositories/warehouse_search_repository.dart';
import 'package:nexus_estoque/core/features/searches/warehouses/providers/remoteWarehouseProvider.dart';

class WarehouseSearchPage extends ConsumerStatefulWidget {
  const WarehouseSearchPage({super.key, this.productWarehouse = const []});

  final List<WarehouseModel> productWarehouse;

  @override
  ConsumerState<WarehouseSearchPage> createState() =>
      _WarehouseSearchPageState();
}

class _WarehouseSearchPageState extends ConsumerState<WarehouseSearchPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<Either<Failure, List<WarehouseModel>>> provider =
        ref.watch(configProvider);
    print(provider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Busca Armazem"),
        centerTitle: true,
      ),
      body: provider.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (data) {
          return data.fold(
            (l) => Text(l.error),
            (r) => Column(
              children: [
                IconButton(
                    onPressed: () {
                      ref.refresh(configProvider);
                      setState(() {});
                    },
                    icon: Icon(Icons.abc)),
                Expanded(
                  child: ListView.builder(
                    itemCount: r.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.pop(context, r[index].codigo);
                          },
                          title: Text(r[index].descricao),
                          subtitle: Text(r[index].codigo),
                          trailing: Text(r[index].filial),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
/*       body: widget.productWarehouse.isEmpty
          ? NetworkWarehouse(ref: ref)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.productWarehouse.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.pop(
                                context, widget.productWarehouse[index].codigo);
                          },
                          title: Text(widget.productWarehouse[index].descricao),
                          subtitle: Text(widget.productWarehouse[index].codigo),
                          trailing: Text(widget.productWarehouse[index].filial),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ), */
    );
  }
}

class NetworkWarehouse extends StatelessWidget {
  const NetworkWarehouse({
    Key? key,
    required this.ref,
  }) : super(key: key);

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WarehouseSearchCubit>(
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
                            onTap: () {
                              Navigator.pop(context, list[index].codigo);
                            },
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
            child: Text("Error"),
          );
        },
      ),
    );
  }
}
