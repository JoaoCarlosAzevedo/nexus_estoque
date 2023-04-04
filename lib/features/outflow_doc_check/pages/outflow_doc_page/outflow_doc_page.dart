import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/outflow_doc_check/data/repositories/outflow_doc_repository.dart';
import 'package:nexus_estoque/features/outflow_doc_check/pages/outflow_doc_page/cubit/outflow_doc_cubit.dart';

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
      body: BlocProvider(
        create: (context) => OutFlowDocCubit(ref.read(outflowDocRepository)),
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
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: state.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          tileColor: Colors.white,
                          title: Text("NF: ${state.docs[index].notaFiscal}"),
                          trailing: Text(
                              "Qtd Prods: ${state.docs[index].produtos.length}"),
                          subtitle:
                              Text("Cliente: ${state.docs[index].nomeCliente}"),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return const Center(
              child: Text("Error"),
            );
          },
        ),
      ),
    );
  }
}
