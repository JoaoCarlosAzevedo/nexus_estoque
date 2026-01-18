import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/outflow_doc_check/data/repositories/outflow_doc_repository.dart';
import 'package:nexus_estoque/features/outflow_doc_check/pages/outflow_doc_page/cubit/outflow_doc_cubit.dart';
import 'package:nexus_estoque/features/outflow_doc_check/pages/outflow_doc_page/widgets/product_list_widget.dart';

import '../../../../core/services/back_buttom_dialog.dart';

class OutFlowDocCheckPage extends ConsumerStatefulWidget {
  const OutFlowDocCheckPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OutFlowDocCheckPageState();
}

class _OutFlowDocCheckPageState extends ConsumerState<OutFlowDocCheckPage> {
  final TextEditingController controller = TextEditingController();
  OutFlowDocCubit? _cubit;
  Completer<void>? _saveCompleter;
  bool _isSavingOnExit = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }

        final bool shouldPop = await showBackDialog(context) ?? false;
        if (context.mounted && shouldPop) {
          // Verifica se há um documento carregado e salva antes de sair
          if (_cubit != null && _cubit!.state is OutFlowDocLoaded) {
            _isSavingOnExit = true;
            _saveCompleter = Completer<void>();
            final state = _cubit!.state as OutFlowDocLoaded;
            _cubit!.saveOutFlowDoc(state.docs);

            // Aguarda o salvamento terminar
            await _saveCompleter!.future;

            if (context.mounted) {
              Navigator.pop(context);
            }
          } else {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text("NF Saida")),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocProvider(
              create: (context) {
                _cubit = OutFlowDocCubit(ref.read(outflowDocRepository));
                return _cubit!;
              },
              child: BlocListener<OutFlowDocCubit, OutFlowDocState>(
                listener: (context, state) {
                  // Se está salvando ao sair e o salvamento terminou
                  if (_isSavingOnExit && _saveCompleter != null) {
                    if (state is OutFlowDocInitial) {
                      // Salvamento concluído com sucesso
                      _isSavingOnExit = false;
                      if (!_saveCompleter!.isCompleted) {
                        _saveCompleter!.complete();
                      }
                      return;
                    }
                    if (state is OutFlowDocPostError) {
                      // Salvamento falhou
                      _isSavingOnExit = false;
                      if (!_saveCompleter!.isCompleted) {
                        _saveCompleter!.complete();
                      }
                      AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              desc: state.failure.error,
                              btnOkOnPress: () {},
                              btnOkColor: Theme.of(context).primaryColor)
                          .show();
                      return;
                    }
                  }

                  if (state is OutFlowDocPostError && !_isSavingOnExit) {
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            desc: state.failure.error,
                            btnOkOnPress: () {},
                            btnOkColor: Theme.of(context).primaryColor)
                        .show();
                  }
                  if (state is OutFlowDocError) {
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            desc: state.failure.error,
                            btnOkOnPress: () {},
                            btnOkColor: Theme.of(context).primaryColor)
                        .show();
                  }
                },
                child: BlocBuilder<OutFlowDocCubit, OutFlowDocState>(
                  builder: (context, state) {
                    if (state is OutFlowDocLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is OutFlowDocLoaded) {
                      return OutFlowDocProductList(
                        document: state.docs,
                        scannedProduct: state.scannedProduct,
                        notFound: state.notFound,
                        barcodeScanned: state.barcode,
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            context.read<OutFlowDocCubit>().checkProduct(value);
                          }
                        },
                        onSave: () {
                          context
                              .read<OutFlowDocCubit>()
                              .postOutFlowDoc(state.docs);
                        },
                        onTapCard: () {},
                        onClose: () {
                          context.read<OutFlowDocCubit>().reset();
                        },
                        onChangeProduct: () {
                          /* context
                              .read<OutFlowDocCubit>()
                              .fetchOutFlowDoc(state.docs.chaveNFe);  */
                        },
                      );
                    }
                    return Column(
                      children: [
                        TextField(
                          autofocus: true,
                          controller: controller,
                          decoration: const InputDecoration(
                            label: Text("Pesquisa NF ou Chave..."),
                          ),
                          onSubmitted: ((value) {
                            context
                                .read<OutFlowDocCubit>()
                                .fetchOutFlowDoc(value);
                            controller.clear();
                          }),
                        ),
                        const Divider(),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<OutFlowDocCubit>()
                                .fetchOutFlowDoc(controller.text);
                            controller.clear();
                          },
                          child: SizedBox(
                            height: height / 15,
                            width: double.infinity,
                            child: const Center(child: Text("Confirmar")),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
