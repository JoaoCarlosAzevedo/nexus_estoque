import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/features/searches/addresses/data/model/address_model.dart';
import 'package:nexus_estoque/core/features/searches/addresses/provider/remote_address_provider.dart';

class AddressSearchModal {
  static Future<String> show(context, String warehouse) async {
    {
      final result = await showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.9,
            child: AddressSearchPage(
              warehouse: warehouse,
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

class AddressSearchPage extends ConsumerStatefulWidget {
  const AddressSearchPage({
    Key? key,
    required this.warehouse,
  }) : super(key: key);
  final String warehouse;

  @override
  ConsumerState<AddressSearchPage> createState() => _AddressSearchPageState();
}

class _AddressSearchPageState extends ConsumerState<AddressSearchPage> {
  List<AddressModel> listAddresses = [];
  List<AddressModel> filterAddresses = [];
  bool resetFilter = true;
  @override
  Widget build(BuildContext context) {
    final futureProvider = ref.watch(remoteAddressProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Busca Endereços"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(remoteAddressProvider);
              resetFilter = true;
            },
            icon: const Icon(Icons.refresh),
          )
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
          listAddresses = data
              .where((element) => element.local == widget.warehouse)
              .toList();

          if (resetFilter) {
            filterAddresses = listAddresses;
            resetFilter = false;
          }

          if (listAddresses.isEmpty) {
            return const Center(child: Text("Nenhum registro encontrado!"));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (e) {
                    addressSearch(e);
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    label: Text("Pesquisar"),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filterAddresses.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.pop(
                                context, filterAddresses[index].codigo);
                          },
                          title: Text(filterAddresses[index].descricao),
                          subtitle: Text(filterAddresses[index].codigo),
                          trailing:
                              Text("Local: ${filterAddresses[index].local}"),
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
    );
  }

  void addressSearch(String value) {
    if (value.isNotEmpty) {
      setState(() {
        filterAddresses = listAddresses.where((element) {
          if (element.codigo.toUpperCase().contains(value.toUpperCase())) {
            return true;
          }

          if (element.descricao.toUpperCase().contains(value.toUpperCase())) {
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
