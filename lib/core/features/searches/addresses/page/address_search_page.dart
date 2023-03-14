import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/features/searches/addresses/data/model/address_model.dart';
import 'package:nexus_estoque/core/features/searches/addresses/provider/remote_address_provider.dart';

class AddressSearchModal {
  static Future<dynamic> show(
      context, String warehouse, ProductBalanceModel product) async {
    {
      BalanceWarehouse? addresses = product.armazem
          .firstWhereOrNull((element) => element.codigo == warehouse);

      final result = await showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.9,
            child: AddressSearchPage(
                warehouse: warehouse,
                data: addresses != null ? addresses.enderecos : []),
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

enum SearchType { all, balance }

class AddressSearchPage extends ConsumerStatefulWidget {
  const AddressSearchPage(
      {required this.warehouse, required this.data, super.key});

  final String warehouse;
  final List<AddressModel> data;

  @override
  AddressSearchPageState createState() => AddressSearchPageState();
}

class AddressSearchPageState extends ConsumerState<AddressSearchPage> {
  SearchType searchSelected = SearchType.all;

  @override
  void initState() {
    if (widget.data.isEmpty) {
      searchSelected = SearchType.all;
    } else {
      searchSelected = SearchType.balance;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Busca Endereço"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                ref.invalidate(remoteAddressProvider);
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //const Text("Busca Endereços"),
              Row(
                children: [
                  Radio<SearchType>(
                    value: SearchType.all,
                    groupValue: searchSelected,
                    onChanged: (SearchType? value) {
                      setState(() {
                        searchSelected = value!;
                      });
                    },
                  ),
                  const Text("Todos")
                ],
              ),
              Row(
                children: [
                  Radio<SearchType>(
                    value: SearchType.balance,
                    groupValue: searchSelected,
                    onChanged: (SearchType? value) {
                      setState(() {
                        searchSelected = value!;
                      });
                    },
                  ),
                  const Text("Saldo")
                ],
              ),
            ],
          ),
          Expanded(
            child: searchSelected == SearchType.all
                ? RemoteAddress(widget.warehouse)
                : AddressList(
                    warehouse: widget.warehouse,
                    data: widget.data,
                  ),
          )
        ],
      ),
    );
  }
}

class RemoteAddress extends ConsumerWidget {
  const RemoteAddress(this.warehouse, {super.key});
  final String warehouse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureProvider = ref.watch(remoteAddressProvider);
    return futureProvider.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          final Failure failure = err as Failure;
          return Center(child: Text(failure.error));
        },
        data: (data) {
          return AddressList(
            warehouse: warehouse,
            data: data,
          );
        });
  }
}

class AddressList extends ConsumerStatefulWidget {
  const AddressList({Key? key, required this.warehouse, required this.data})
      : super(key: key);
  final String warehouse;
  final List<AddressModel> data;

  @override
  ConsumerState<AddressList> createState() => _AddressListState();
}

class _AddressListState extends ConsumerState<AddressList> {
  List<AddressModel> listAddresses = [];
  List<AddressModel> filterAddresses = [];
  bool resetFilter = true;
  @override
  Widget build(BuildContext context) {
    listAddresses = widget.data
        .where((element) => element.local == widget.warehouse)
        .toList();

    if (resetFilter) {
      filterAddresses = listAddresses;
      resetFilter = false;
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
                      Navigator.pop(context, filterAddresses[index]);
                    },
                    title: Text(filterAddresses[index].descricao),
                    subtitle: Text(
                        "${filterAddresses[index].local} - ${filterAddresses[index].codigo}"),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(filterAddresses[index].lote),
                        if (filterAddresses[index].quantidade != 0)
                          Text(
                            "${filterAddresses[index].quantidade}",
                          ),
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
