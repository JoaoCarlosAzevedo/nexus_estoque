import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';

import '../data/model/address_tag_model.dart';
import '../data/repositories/address_tag_repository.dart';
import 'address_tag_streets_page.dart';

class AddressTagListPage extends ConsumerStatefulWidget {
  const AddressTagListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressTagListPageState();
}

class _AddressTagListPageState extends ConsumerState<AddressTagListPage> {
  List<AddressTagModel> filterListAddresses = [];
  List<AddressTagModel> listAddresses = [];

  @override
  Widget build(BuildContext context) {
    final futureProvider = ref.watch(remoteAddressTagListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta Endereços"),
        actions: [
          IconButton(
              onPressed: () {
                ref.invalidate(remoteAddressTagListProvider);
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: futureProvider.when(
        skipLoadingOnRefresh: false,
        data: (data) {
          listAddresses = data;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: GroupedListView<AddressTagModel, String>(
                    elements: data,
                    groupBy: (element) => element.groupbyDepartamento(),
                    groupSeparatorBuilder: (String groupByValue) {
                      final ruas = data
                          .where(
                            (element) => element
                                .groupbyDepartamento()
                                .contains(groupByValue),
                          )
                          .toList();

                      Set<String> qtdRuas = {};

                      for (var element in ruas) {
                        qtdRuas.add(element.rua);
                      }

                      final endereco = ruas.first;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddressTagStreetListPage(
                                  department: groupByValue,
                                ),
                              ),
                            );
                          },
                          title: Text("Armazem ${endereco.armazem} "),
                          //subtitle: Text("Ruas: ${qtdRuas.length}"),
                          subtitle:
                              Text("Departamento: ${endereco.departamento}"),
                          leading: const FaIcon(FontAwesomeIcons.warehouse),
                        ),
                      );
                    },
                    itemBuilder: (context, AddressTagModel element) {
                      return Container();
                    },
                    useStickyGroupSeparators: false, // optional
                    floatingHeader: false, // optional
                    order: GroupedListOrder.ASC, // optional
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
}
