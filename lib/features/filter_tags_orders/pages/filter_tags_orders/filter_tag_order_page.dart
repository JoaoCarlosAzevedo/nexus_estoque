import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/services/bt_printer.dart';

import '../../../../core/features/bluetooth_printer/bluetooth_printer.dart';
import '../../data/repositories/filter_tag_order_repository.dart';
import 'cubit/filter_tag_order_cubit.dart';

class FilterTagsOrderPage extends ConsumerStatefulWidget {
  const FilterTagsOrderPage({super.key, required this.pedido});
  final String pedido;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FilterTagsOrderPageState();
}

class _FilterTagsOrderPageState extends ConsumerState<FilterTagsOrderPage> {
  bool filterFaturado = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FilterTagOrderCubit(
          ref.read(filterTagRepositoryProvider), widget.pedido),
      child: BlocBuilder<FilterTagOrderCubit, FilterTagOrderState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Etiquetas Pedido - ${widget.pedido}"),
              actions: [
                IconButton(
                    onPressed: () {
                      context
                          .read<FilterTagOrderCubit>()
                          .fetchFilterTags(widget.pedido);
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<FilterTagOrderCubit, FilterTagOrderState>(
                  builder: (context, state) {
                    if (state is FilterTagInvoiceInitial) {
                      return const Center(
                        child: Text("Initial"),
                      );
                    }
                    if (state is FilterTagInvoiceLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is FilterTagInvoiceError) {
                      return Center(
                        child: Text(state.error.error),
                      );
                    }

                    if (state is FilterTagInvoiceLoaded) {
                      final data = state.tags;
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      /*  final cubit = */
                                      /*      context.read<FilterTagInvoiceCubit>(); */
                                      /*  cubit.setSelectedInvoice(data.pedidos[index]); */
                                    },
                                    leading: IconButton(
                                        onPressed: () async {
                                          final isPrinted =
                                              await BluetoothPrinter.printZPL(
                                                  data[index].etiqueta);
                                          if (!isPrinted) {
                                            // ignore: use_build_context_synchronously
                                            BluetoothPageModal.show(context);
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.print,
                                          color: Colors.green,
                                        )),
                                    title: Text(
                                        'Embalagem: ${data[index].embalagem}'),
                                    subtitle: Text(
                                        "Itens: ${data[index].itens.length}"),
                                    trailing: IconButton(
                                        onPressed: () {
                                          final cubit = context
                                              .read<FilterTagOrderCubit>();
                                          cubit.deleteTag(data[index]);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    return const Text("Initial");
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
