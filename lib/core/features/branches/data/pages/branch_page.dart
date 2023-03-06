import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/features/branches/data/provider/remote_branche_provider.dart';

import '../model/branch_model.dart';

class BranchPange extends ConsumerWidget {
  const BranchPange({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureProvider = ref.watch(remoteBranchProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grupo / Filial"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                ref.invalidate(remoteBranchProvider);
              },
              icon: const Icon(Icons.refresh)),
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
            return BranchList(
              data: data,
            );
          }),
    );
  }
}

class BranchList extends StatelessWidget {
  const BranchList({super.key, required this.data});
  final List<Branch> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: GroupedListView<Branch, String>(
              elements: data,
              groupBy: (element) =>
                  "${element.groupCode} - ${element.groupName}",
              groupSeparatorBuilder: (String groupByValue) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          groupByValue,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemBuilder: (context, Branch element) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      //Navigator.pop(context, data.);
                    },
                    title:
                        Text("${element.branchCode} - ${element.branchName}"),
                    subtitle:
                        Text("${element.groupCode} - ${element.groupName}"),
                    trailing: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.memory(
                        base64Decode(element.logo),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
              useStickyGroupSeparators: true, // optional
              floatingHeader: true, // optional
              order: GroupedListOrder.ASC, // optional
            ),
            /*      child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context, data[index]);
                    },
                    title: Text(data[index].branchName),
                    subtitle: Text(
                        "${data[index].branchCode} - ${data[index].groupCode}"),
                    trailing: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Image.memory(
                        base64Decode(data[index].logo),
                      ),
                    ),
                  ),
                );
              },
            ), */
          ),
        ],
      ),
    );
  }
}
