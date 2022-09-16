import 'package:flutter/material.dart';
import 'package:nexus_estoque/features/query_address/data/model/query_address_model.dart';
import 'package:nexus_estoque/features/query_address/data/repositories/query_address_repository.dart';

class SearchAddress extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'ex: código, descriçao ou código de barras';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  //quando submita
  @override
  Widget buildResults(BuildContext context) {
    return ListView(
      children: const [
        Text("1"),
        Text("2"),
        Text("3"),
      ],
    );
  }

  //quando entrana pagina / edita
  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<QueryAddressModel>?>(
      future: fetchData(),
      builder: (context, snapshot) {
        print(snapshot.data);
        if (snapshot.hasData) {
          return ListView(
            children: [Text("1"), Text("2"), Text('${snapshot.data!.length}')],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<List<QueryAddressModel>> fetchData() async {
    final QueryAddressRepository repository = QueryAddressRepository();

    final result = await repository.fetchAdress();

    result.fold((l) {
      throw Exception("Erro ao carregador dados");
    }, (r) {
      return r;
    });
  }
}
