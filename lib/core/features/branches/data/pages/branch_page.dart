import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/features/branches/data/provider/remote_branche_provider.dart';
import 'package:nexus_estoque/core/services/secure_store.dart';

import '../model/branch_model.dart';

class BranchPage extends ConsumerStatefulWidget {
  const BranchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BranchPageState();
}

class _BranchPageState extends ConsumerState<BranchPage> {
  String branchCode = '';
  String groupCode = '';

  void getBranch() async {
    final Branch? branch = await LocalStorage.getBranch();
    branchCode = branch?.branchCode.trim() ?? "";
    groupCode = branch?.groupCode.trim() ?? "";
  }

  @override
  void initState() {
    super.initState();
    getBranch();
  }

  @override
  Widget build(BuildContext context) {
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
            branchCode: branchCode,
            groupCode: groupCode,
            onTap: (element) async {
              ref.invalidate(environmentProvider);
              await LocalStorage.saveBranch(element);
              setState(() {
                getBranch();
              });
            },
          );
        },
      ),
    );
  }
}

class BranchList extends StatelessWidget {
  const BranchList({
    super.key,
    required this.data,
    required this.branchCode,
    required this.groupCode,
    required this.onTap,
  });

  final List<Branch> data;
  final String branchCode;
  final String groupCode;
  final void Function(Branch) onTap;

  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
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
                if (element.branchCode == branchCode &&
                    element.groupCode == groupCode) {
                  isSelected = true;
                } else {
                  isSelected = false;
                }
                return Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 4,
                        color: isSelected ? Colors.grey : Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(20.0)),
                  child: ListTile(
                      onTap: () {
                        onTap(element);
                      },
                      title:
                          Text("${element.branchCode} - ${element.branchName}"),
                      subtitle:
                          Text("${element.groupCode} - ${element.groupName}"),
                      trailing: LogoWidget(
                        logo: element.logo,
                      )),
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

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key, required this.logo});
  final String logo;
  @override
  Widget build(BuildContext context) {
    if (logo.trim().isEmpty) {
      return const Icon(
        Icons.business,
        color: Colors.grey,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.memory(
        base64Decode(logo),
        fit: BoxFit.contain,
      ),
    );
  }
}
