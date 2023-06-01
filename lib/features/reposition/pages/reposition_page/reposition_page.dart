import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/reposition/data/model/reposition_model.dart';
import 'package:nexus_estoque/features/reposition/data/model/reposition_transfer_moderl.dart';
import 'package:nexus_estoque/features/reposition/data/repositories/reposition_repository.dart';
import 'package:nexus_estoque/features/reposition/pages/reposition_page/cubit/reposition_cubit.dart';
import 'package:nexus_estoque/features/reposition/pages/reposition_product_check/reposition_product_check_page.dart';

import 'widgets/reposition_card_widget.dart';

class RepositionPage extends ConsumerStatefulWidget {
  const RepositionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RepositionPageState();
}

class _RepositionPageState extends ConsumerState<RepositionPage> {
  List<RepositionModel> listReposition = [];
  List<RepositionModel> filterList = [];
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reposição')),
      body: BlocProvider(
        create: (context) =>
            RepositionCubit(repository: ref.read(repositionRepositoryProvider)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                showCursor: true,
                autofocus: true,
                controller: controller,
                onChanged: (e) {
                  setState(() {});
                  //search(e);
                },
                onSubmitted: (e) {
                  //search(e);
                  setState(() {});
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  label: Text("Produto / Endereço"),
                ),
              ),
              const Divider(),
              Expanded(
                child: BlocBuilder<RepositionCubit, RepositionState>(
                  builder: (context, state) {
                    if (state is RepositionLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is RepositionError) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<RepositionCubit>().fetchReposition();
                        },
                        child: Center(
                          child: Text(state.error.error),
                        ),
                      );
                    }
                    if (state is RepositionLoaded) {
                      final repositions = state.repositions;
                      listReposition = repositions;
                      filterList = filter(controller.text);

                      if (filterList.isEmpty) {
                        return const Center(
                          child: Text("Nenhum registro encontrado."),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<RepositionCubit>().fetchReposition();
                        },
                        child: ListView.builder(
                          itemCount: filterList.length,
                          itemBuilder: (context, index) {
                            return RepositionCard(
                              reposition: filterList[index],
                              onTap: () {
                                onTap(context, filterList[index]);
                              },
                            );
                          },
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<RepositionModel> filter(String search) {
    return listReposition.where((element) {
      if (element.descEndereco.toUpperCase().contains(search.toUpperCase())) {
        return true;
      }

      if (element.descEnderecoRetira
          .toUpperCase()
          .contains(search.toUpperCase())) {
        return true;
      }

      if (element.codProduto.toUpperCase().contains(search.toUpperCase())) {
        return true;
      }

      return false;
    }).toList();
  }

  void onTap(BuildContext context, RepositionModel reposition) {
    final productReposition = RepositionTrasnferModel(
        product: reposition.codProduto,
        origAddress: reposition.codEnderecoRetira,
        destAddress: reposition.codEndereco,
        quantity: reposition.quantAbastecer,
        warehouse: reposition.local);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RepositionProductCheck(
          productReposition: productReposition,
        ),
      ),
    );
  }
}
