import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/outflow_doc_check/data/repositories/outflow_doc_repository.dart';
import 'package:nexus_estoque/features/outflow_doc_check/pages/outflow_doc_page/cubit/outflow_doc_cubit.dart';
import 'package:nexus_estoque/features/outflow_doc_check/pages/outflow_doc_page/widgets/product_list_widget.dart';

class OutFlowDocCheckPage extends ConsumerStatefulWidget {
  const OutFlowDocCheckPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OutFlowDocCheckPageState();
}

class _OutFlowDocCheckPageState extends ConsumerState<OutFlowDocCheckPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NF Saida")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocProvider(
            create: (context) =>
                OutFlowDocCubit(ref.read(outflowDocRepository)),
            child: BlocBuilder<OutFlowDocCubit, OutFlowDocState>(
              builder: (context, state) {
                if (state is OutFlowDocLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is OutFlowDocError) {
                  return Center(
                    child: Text(state.failure.error),
                  );
                }

                if (state is OutFlowDocLoaded) {
                  return OutFlowDocProductList(
                    document: state.docs,
                    scannedProduct: state.scannedProduct,
                    notFound: state.notFound,
                    onSubmitted: (value) {
                      context.read<OutFlowDocCubit>().checkProduct(value);
                    },
                    onSave: () {
                      print("teste");
                      context
                          .read<OutFlowDocCubit>()
                          .fetchOutFlowDoc(state.docs.chaveNFe);
                    },
                  );

                  /* return CustomScrollView(
                    slivers: [ 
                      SliverFillRemaining(
                        hasScrollBody: true,
                        child: Column(
                          children: [
                            TextField(
                              autofocus: true,
                              decoration: const InputDecoration(
                                label: Text("Cód. Barras ou SKU..."),
                              ),
                              onSubmitted: ((value) {
                                /*       final index = state.docs.produtos.indexWhere(
                                    (element) =>
                                        element.codigo.trim() == value.trim());
                                if (index >= 0) {
                                  setState(() {
                                    state.docs.produtos[index].checked += 1;
                                  });
                                } */
                                context
                                    .read<OutFlowDocCubit>()
                                    .checkProduct(value);
                                setState(() {});
                              }),
                            ),
                            Expanded(
                              child: ListView.builder(
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                itemCount: state.docs.produtos.length,
                                itemBuilder: (context, index) {
                                  final products = state.docs.produtos[index];
                                  return Card(
                                    child: ListTile(
                                      tileColor: Colors.white,
                                      title: Text("NF: ${products.descricao}"),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              "Qtd Prods: ${products.quantidade}"),
                                          Text(
                                              "Qtd Check: ${products.checked}"),
                                        ],
                                      ),
                                      subtitle:
                                          Text("Cliente: ${products.codigo}"),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ); */
                }
                return Column(
                  children: [
                    TextField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        label: Text("Pesquisa..."),
                      ),
                      onSubmitted: ((value) {
                        context.read<OutFlowDocCubit>().fetchOutFlowDoc(value);
                      }),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
