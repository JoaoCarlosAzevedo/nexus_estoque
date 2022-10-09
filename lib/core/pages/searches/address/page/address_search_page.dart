import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nexus_estoque/core/pages/searches/address/cubit/address_search_cubit.dart';
import 'package:nexus_estoque/core/pages/searches/address/cubit/address_search_state.dart';
import 'package:nexus_estoque/core/pages/searches/address/data/repositories/address_search_repository.dart';

class AddressSearchPage extends StatefulWidget {
  const AddressSearchPage({
    Key? key,
    required this.warehouse,
  }) : super(key: key);
  final String warehouse;

  @override
  State<AddressSearchPage> createState() => _AddressSearchPageState();
}

class _AddressSearchPageState extends State<AddressSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Busca Endereços"),
        centerTitle: true,
      ),
      body: BlocProvider<AddressSearchCubit>(
        create: (context) =>
            AddressSearchCubit(AddressSearchRepository(), widget.warehouse),
        child: BlocBuilder<AddressSearchCubit, AddressSearchState>(
          builder: (context, state) {
            if (state is AddressSearchLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is AddressSearchError) {
              return Center(
                child: Text(state.error.error),
              );
            }

            if (state is AddressSearchLoaded) {
              final list = state.addressess;
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<AddressSearchCubit>()
                      .fetchAddress(widget.warehouse);
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
                                Navigator.pop(
                                    context, list[index].codigoEndereco);
                              },
                              title: Text(list[index].descricao),
                              subtitle: Text(list[index].codigoEndereco),
                              trailing: Text(list[index].local),
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
