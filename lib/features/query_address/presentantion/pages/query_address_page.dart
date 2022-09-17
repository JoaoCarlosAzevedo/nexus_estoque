import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:nexus_estoque/core/error/failure.dart';
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
    return FutureBuilder<Either<Failure, List<QueryAddressModel>>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is Failure) {
            return const Center(
              child: Text("Erro"),
            );
          }

          List<QueryAddressModel> list = [];
          List<QueryAddressModel> filteredList = [];

          if (snapshot.data!.isRight()) {
            snapshot.data!.fold((l) => {}, (r) => list = r);
          }
          if (query.isNotEmpty) {
            filteredList = list.where((element) {
              if (element.description
                  .toUpperCase()
                  .contains(query.toUpperCase())) {
                return true;
              }
              if (element.code.toUpperCase().contains(query.toUpperCase())) {
                return true;
              }
              return false;
            }).toList();
          }
          if (filteredList.isEmpty) {
            filteredList = list;
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      close(context, filteredList[index].code);
                    },
                    title: Text(
                        "${filteredList[index].code} - ${filteredList[index].description} "),
                  ),
                );
              },
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  //quando entrana pagina / edita
  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<Either<Failure, List<QueryAddressModel>>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is Failure) {
            return const Center(
              child: Text("Erro"),
            );
          }

          List<QueryAddressModel> list = [];
          List<QueryAddressModel> filteredList = [];

          if (snapshot.data!.isRight()) {
            snapshot.data!.fold((l) => {}, (r) => list = r);
          }
          if (query.isNotEmpty) {
            filteredList = list.where((element) {
              if (element.description
                  .toUpperCase()
                  .contains(query.toUpperCase())) {
                return true;
              }
              if (element.code.toUpperCase().contains(query.toUpperCase())) {
                return true;
              }
              return false;
            }).toList();
          }
          if (filteredList.isEmpty) {
            filteredList = list;
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      close(context, filteredList[index].code);
                    },
                    title: Text(
                        "${filteredList[index].code} - ${filteredList[index].description} "),
                  ),
                );
              },
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<Either<Failure, List<QueryAddressModel>>> fetchData() async {
    final QueryAddressRepository repository = QueryAddressRepository();

    await Future.delayed(const Duration(milliseconds: 2000));

    final result = await repository.fetchAdress(query);

    return result;
  }
}
