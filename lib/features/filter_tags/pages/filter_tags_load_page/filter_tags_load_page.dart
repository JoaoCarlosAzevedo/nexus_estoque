import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/repositories/filter_tag_repository.dart';
import '../filter_tags_invoice/filter_tag_invoice_page.dart';
import '../filter_tags_invoice_products_page/filter_tags_invoice_products_page.dart';
import 'cubit/filter_tag_load_cubit.dart';

class FilterTagsLoadPage extends ConsumerStatefulWidget {
  const FilterTagsLoadPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FilterTagsLoadPageState();
}

class _FilterTagsLoadPageState extends ConsumerState<FilterTagsLoadPage> {
  bool filterFaturado = false;
  final TextEditingController controller =
      TextEditingController(text: '092225');

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) =>
          FilterTagLoadCubit(ref.read(filterTagRepositoryProvider)),
      child: BlocBuilder<FilterTagLoadCubit, FilterTagLoadState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Cargas x NF`s"),
              actions: [
                IconButton(
                    onPressed: () {
                      context
                          .read<FilterTagLoadCubit>()
                          .fetchLoad(controller.text);
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<FilterTagLoadCubit, FilterTagLoadState>(
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
                              context
                                  .read<FilterTagLoadCubit>()
                                  .fetchLoad(controller.text);
                            }),
                          ),
                          const Divider(),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<FilterTagLoadCubit>()
                                  .fetchLoad(controller.text);
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
                              itemCount: data.nfs.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      final cubit =
                                          context.read<FilterTagLoadCubit>();
                                      cubit.setSelectedInvoice(data.nfs[index]);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FilterTagsInvoiceProductsPage(
                                            cubit: cubit,
                                          ),
                                        ),
                                      );
                                    },
                                    title: Text(
                                        'NF: ${data.nfs[index].notaFiscal}'),
                                    subtitle: Text(data.nfs[index].nomeCliente),
                                    trailing: data.nfs[index].hasTag()
                                        ? IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FilterTagsInvoicePage(
                                                    nf: data
                                                        .nfs[index].notaFiscal,
                                                    serie:
                                                        data.nfs[index].serie,
                                                  ),
                                                ),
                                              );
                                              //FilterTagsLoadPage
                                            },
                                            icon: const FaIcon(
                                              FontAwesomeIcons.boxOpen,
                                              color: Colors.green,
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
