import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/features/bluetooth_printer/bluetooth_printer.dart';
import '../../../../core/services/bt_printer.dart';
import '../filter_tags_order_load_page/cubit/filter_tag_order_load_cubit.dart';
import 'filter_tag_order_tab1.dart';
import 'filter_tag_order_tab2.dart';

class FilterTagsOrderProductsPage extends ConsumerStatefulWidget {
  const FilterTagsOrderProductsPage(
      {required this.cubit, super.key, this.orderBydate});

  final FilterTagLoadOrderCubit cubit;
  final String? orderBydate;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FilterTagsOrderProductsPageState();
}

class _FilterTagsOrderProductsPageState
    extends ConsumerState<FilterTagsOrderProductsPage> {
  bool filterFaturado = false;
  bool isPrinted = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Seleção de Produtos"),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Row(
                  children: [
                    Text("Itens Pedido"),
                    SizedBox(
                      width: 10,
                    ),
                    FaIcon(
                      FontAwesomeIcons.clipboardCheck,
                    ),
                  ],
                ),
              ),
              Tab(
                icon: Row(
                  children: [
                    Text("Embalagem"),
                    SizedBox(
                      width: 10,
                    ),
                    FaIcon(
                      FontAwesomeIcons.boxOpen,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: BlocProvider.value(
            value: widget.cubit,
            child:
                BlocListener<FilterTagLoadOrderCubit, FilterTagLoadOrderState>(
              listener: (context, state) async {
                if (state is FilterTagLoadLoaded) {
                  if (state.etiqueta.isNotEmpty) {
                    final isPrinted =
                        await BluetoothPrinter.printZPL(state.etiqueta);
                    if (!isPrinted) {
                      // ignore: use_build_context_synchronously
                      BluetoothPageModal.show(context);
                      return;
                    }

                    if (isPrinted && state.selectedInvoice == null) {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      return;
                    }
                  }

                  if (state.selectedInvoice == null) {
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }

                  if (state.error.isNotEmpty) {
                    AwesomeDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            desc: state.error,
                            btnOkOnPress: () {},
                            // ignore: use_build_context_synchronously
                            btnOkColor: Theme.of(context).primaryColor)
                        .show();
                  }
                }
              },
              child:
                  BlocBuilder<FilterTagLoadOrderCubit, FilterTagLoadOrderState>(
                builder: (context, state) {
                  if (state is FilterTagLoadError) {
                    return const Center(
                      child: Text("Error"),
                    );
                  }
                  if (state is FilterTagLoadLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is FilterTagLoadInitial) {
                    return const Center(
                      child: Text("Invalid State"),
                    );
                  }

                  if (state is FilterTagLoadLoaded) {
                    if (state.selectedInvoice == null) {
                      return Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            final isPrinted =
                                await BluetoothPrinter.printZPL(state.etiqueta);
                            if (!isPrinted) {
                              // ignore: use_build_context_synchronously
                              BluetoothPageModal.show(context);
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text("Imprimir"),
                          ),
                        ),
                      );
                    }

                    return TabBarView(
                      children: [
                        FilterTagOrderTab1(order: state.selectedInvoice!),
                        FilterTagOrderTab2(
                          pedido: state.selectedInvoice!,
                          etiqueta: state.etiqueta,
                          orderBydate: widget.orderBydate,
                        ),
                      ],
                    );
                  }
                  return const Center(
                    child: Text("Invalid state!"),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
