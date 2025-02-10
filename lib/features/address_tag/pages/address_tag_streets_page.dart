import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';

import '../data/model/address_tag_model.dart';
import '../data/repositories/address_tag_repository.dart';
import 'address_tag_streets_builds_page.dart';

class AddressTagStreetListPage extends ConsumerStatefulWidget {
  const AddressTagStreetListPage({super.key, required this.department});
  final String department;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressTagStreetListPageState();
}

class _AddressTagStreetListPageState
    extends ConsumerState<AddressTagStreetListPage> {
  List<AddressTagModel> filterListAddresses = [];
  List<AddressTagModel> listAddresses = [];

  @override
  Widget build(BuildContext context) {
    final futureProvider = ref.watch(remoteAddressTagListProvider);
    final map = addressToMap(widget.department);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("Armazém ${map["armazem"]}"),
            Text("Departamento ${map["departamento"]} "),
          ],
        ),
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
          listAddresses = data
              .where((element) =>
                  element.groupbyDepartamento().contains(widget.department))
              .toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: GroupedListView<AddressTagModel, String>(
                    elements: listAddresses,
                    groupBy: (element) => element.groupbyDepartamentoRua(),
                    groupSeparatorBuilder: (String groupByValue) {
                      final ruas = listAddresses
                          .where(
                            (element) => element
                                .groupbyDepartamentoRua()
                                .contains(groupByValue),
                          )
                          .toList();

                      Set<String> qtdPredios = {};

                      for (var element in ruas) {
                        qtdPredios.add(element.predio);
                      }

                      final endereco = ruas.first;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddressTagStreetBuildListPage(
                                  building: groupByValue,
                                ),
                              ),
                            );
                          },
                          leading: const FaIcon(FontAwesomeIcons.road),
                          trailing: IconButton(
                            onPressed: () {
                              context.push("/etiqueta_endereco/$groupByValue");
                            },
                            color: Colors.green,
                            icon: const FaIcon(FontAwesomeIcons.print),
                          ),
                          title: Text("Rua ${endereco.rua} "),
                          subtitle: Text("Prédios: ${qtdPredios.length}"),
                        ),
                      );
                    },
                    itemBuilder: (context, AddressTagModel element) {
                      return Container();
                    },
                    useStickyGroupSeparators: true, // optional
                    floatingHeader: true, // optional
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
