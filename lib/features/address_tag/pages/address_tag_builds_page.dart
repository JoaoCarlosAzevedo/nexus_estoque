import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../data/model/address_tag_model.dart';
import '../data/repositories/address_tag_repository.dart';

class AddressTagBuildListPage extends ConsumerStatefulWidget {
  const AddressTagBuildListPage({super.key, required this.build});
  final String build;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressTagBuildListPageState();
}

class _AddressTagBuildListPageState
    extends ConsumerState<AddressTagBuildListPage> {
  List<AddressTagModel> listAddresses = [];

  @override
  Widget build(BuildContext context) {
    final futureProvider = ref.watch(remoteAddressTagListProvider);
    final map = addressToMap(widget.build);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("Armazém ${map["armazem"]}"),
            Text("${map["departamento"]} - ${map["rua"]} - ${map["predio"]}"),
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
                  element.groupbyDepartamentoRuaPredio().contains(widget.build))
              .toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: listAddresses.length,
                    itemBuilder: (context, index) {
                      final element = listAddresses[index];

                      return Card(
                        margin: const EdgeInsets.only(top: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Prédio ${element.predio} - ',
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .copyWith(color: Colors.orange),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Nível ${element.nivel} - ',
                                        style: DefaultTextStyle.of(context)
                                            .style
                                            .copyWith(color: Colors.green),
                                      ),
                                      TextSpan(
                                        text: 'Apto. ${element.apartamento}',
                                        style: DefaultTextStyle.of(context)
                                            .style
                                            .copyWith(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  element.descricao,
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    context.push(
                                        "/etiqueta_endereco/${element.fullAddress()}");
                                  },
                                  color: Colors.green,
                                  icon: const FaIcon(FontAwesomeIcons.print),
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(),
                                    Text(
                                      "Código: ${element.codEndereco}",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                visualDensity: VisualDensity.compact,
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
