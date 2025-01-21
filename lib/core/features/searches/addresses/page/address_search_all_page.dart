import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../error/failure.dart';
import '../provider/remote_address_provider.dart';
import 'address_search_page.dart';

class AllAddressSearchModal {
  static Future<dynamic> show(
    context,
  ) async {
    {
      final result = await showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.9,
            child: Container(),
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

class AllAddressSearchPageState extends ConsumerState<AddressSearchPage> {
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

class RemoteAllAddress extends ConsumerWidget {
  const RemoteAllAddress(this.warehouse, {super.key});
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
