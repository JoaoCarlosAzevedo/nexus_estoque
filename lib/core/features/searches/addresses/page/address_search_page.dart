import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/features/searches/addresses/provider/remote_address_provider.dart';

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
  @override
  Widget build(BuildContext context) {
    final futureProvider = ref.watch(remoteAddressProvider(widget.warehouse));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Busca Endereços"),
        centerTitle: true,
      ),
      body: futureProvider.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          final Failure failure = err as Failure;
          return Center(child: Text(failure.error));
        },
        data: (data) {
          return Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.pop(context, data[index].codigoEndereco);
                          },
                          title: Text(data[index].descricao),
                          subtitle: Text(data[index].codigoEndereco),
                          trailing: Text(data[index].local),
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
}
