import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/repositories/filter_tag_order_repository.dart';
import '../filter_tags_order_products_page/filter_tags_order_products_page.dart';
import '../filter_tags_orders/filter_tag_order_page.dart';

import 'cubit/filter_tag_order_load_cubit.dart';

class FilterTagsOrderLoadPage extends ConsumerStatefulWidget {
  const FilterTagsOrderLoadPage({super.key, required this.load});
  final String load;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FilterTagsOrderLoadPageState();
}

class _FilterTagsOrderLoadPageState
    extends ConsumerState<FilterTagsOrderLoadPage> {
  bool filterFaturado = false;
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => FilterTagLoadOrderCubit(
          ref.read(filterTagRepositoryProvider), widget.load),
      child: BlocBuilder<FilterTagLoadOrderCubit, FilterTagLoadOrderState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Cargas x Pedidos"),
              actions: [
                IconButton(
                    onPressed: () {
                      context.read<FilterTagLoadOrderCubit>().fetchLoad(
                          widget.load.isEmpty ? controller.text : widget.load,
                          "");
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<FilterTagLoadOrderCubit,
                    FilterTagLoadOrderState>(
                  builder: (context, state) {
                    if (state is FilterTagLoadInitial) {
                      return Column(
                        children: [
                          TextField(
                            autofocus: true,
                            controller: controller,
                            decoration: const InputDecoration(
                              label: Text("Informe o número da carga..."),
                            ),
                            onSubmitted: ((value) {
                              if (value.trim().isNotEmpty) {
                                context
                                    .read<FilterTagLoadOrderCubit>()
                                    .fetchLoad(controller.text, "");
                              }
                            }),
                          ),
                          const Divider(),
                          ElevatedButton(
                            onPressed: () {
                              if (controller.text.trim().isNotEmpty) {
                                context
                                    .read<FilterTagLoadOrderCubit>()
                                    .fetchLoad(controller.text, "");
                              }
                            },
                            child: SizedBox(
                              height: height / 15,
                              width: double.infinity,
                              child: const Center(child: Text("Confirmar")),
                            ),
                          ),
                        ],
                      );
                    }
                    if (state is FilterTagLoadLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is FilterTagLoadError) {
                      return Center(
                        child: Text(state.error.error),
                      );
                    }

                    if (state is FilterTagLoadLoaded) {
                      final data = state.load;
                      return Column(
                        children: [
                          Text(
                            "Carga ${data.carga}",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: data.pedidos.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      final cubit = context
                                          .read<FilterTagLoadOrderCubit>();
                                      cubit.setSelectedInvoice(
                                          data.pedidos[index]);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FilterTagsOrderProductsPage(
                                            cubit: cubit,
                                          ),
                                        ),
                                      );
                                    },
                                    title: Text(
                                        'Pedido: ${data.pedidos[index].pedido}'),
                                    subtitle:
                                        Text(data.pedidos[index].nomeCliente),
                                    trailing: data.pedidos[index].hasTag()
                                        ? IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FilterTagsOrderPage(
                                                    pedido: data
                                                        .pedidos[index].pedido,
                                                  ),
                                                ),
                                              );
                                              //FilterTagsOrderLoadPage
                                            },
                                            icon: FaIcon(
                                              FontAwesomeIcons.boxOpen,
                                              color: data.pedidos[index]
                                                  .statusTags(),
                                            ),
                                          )
                                        : FaIcon(
                                            FontAwesomeIcons.boxOpen,
                                            color: Colors.grey.shade300,
                                          ),
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
