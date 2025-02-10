import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';

import '../data/model/address_tag_model.dart';
import '../data/repositories/address_tag_repository.dart';
import 'address_tag_builds_page.dart';

class AddressTagStreetBuildListPage extends ConsumerStatefulWidget {
  const AddressTagStreetBuildListPage({super.key, required this.building});
  final String building;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressTagStreetBuildListPageState();
}

class _AddressTagStreetBuildListPageState
    extends ConsumerState<AddressTagStreetBuildListPage> {
  List<AddressTagModel> listAddresses = [];

  @override
  Widget build(BuildContext context) {
    final futureProvider = ref.watch(remoteAddressTagListProvider);
    final map = addressToMap(widget.building);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("Armazém ${map["armazem"]}"),
            Text("Dep. ${map["departamento"]} - Rua ${map["rua"]} ")
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
                  element.groupbyDepartamentoRua().contains(widget.building))
              .toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: GroupedListView<AddressTagModel, String>(
                    elements: listAddresses,
                    groupBy: (element) =>
                        element.groupbyDepartamentoRuaPredio(),
                    groupSeparatorBuilder: (String groupByValue) {
                      final ruas = listAddresses
                          .where(
                            (element) => element
                                .groupbyDepartamentoRuaPredio()
                                .contains(groupByValue),
                          )
                          .toList();

                      Set<String> qtdApartamentos = {};

                      for (var element in ruas) {
                        qtdApartamentos.add(element.apartamento);
                      }

                      final endereco = ruas.first;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddressTagBuildListPage(
                                  build: groupByValue,
                                ),
                              ),
                            );
                          },
                          leading: const FaIcon(FontAwesomeIcons.building),
                          trailing: IconButton(
                            onPressed: () {
                              context.push("/etiqueta_endereco/$groupByValue");
                            },
                            color: Colors.green,
                            icon: const FaIcon(FontAwesomeIcons.print),
                          ),
                          title: Text("Prédio ${endereco.predio}"),
                          subtitle:
                              Text("Apartamentos: ${qtdApartamentos.length}"),
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
