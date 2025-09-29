import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:nexus_estoque/core/theme/app_colors.dart';

import '../../../../core/utils/datetime_formatter.dart';

import '../../data/repositories/filter_tag_order_repository.dart';

import '../filter_tags_order_load_page/cubit/filter_tag_order_load_cubit.dart';
import '../filter_tags_order_products_page/filter_tags_order_products_page.dart';
import '../filter_tags_orders/filter_tag_order_page.dart';

class FilterTagsOrdersbyDatePage extends ConsumerStatefulWidget {
  const FilterTagsOrdersbyDatePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FilterTagsOrdersbyDatePageState();
}

class _FilterTagsOrdersbyDatePageState
    extends ConsumerState<FilterTagsOrdersbyDatePage> {
  late String dateIni;
  late String dateEnd;
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    dateIni = datetimeToYYYYMMDD(DateTime.now());
    dateEnd = datetimeToYYYYMMDD(DateTime.now());
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => FilterTagLoadOrderCubit(
          ref.read(filterTagRepositoryProvider), "0-$dateIni-$dateEnd"),
      child: BlocBuilder<FilterTagLoadOrderCubit, FilterTagLoadOrderState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Column(
                children: [
                  const Text("Pedidos por Data"),
                  Text(
                    "${yyyymmddToDate(dateIni)} - ${yyyymmddToDate(dateEnd)}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () async {
                      await pickeDateRange(context);
                      context
                          .read<FilterTagLoadOrderCubit>()
                          .fetchLoad("0-$dateIni-$dateEnd", "", null);
                    },
                    icon: const Icon(Icons.calendar_month)),
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
                              /*  if (value.trim().isNotEmpty) {
                                context
                                    .read<FilterTagLoadOrderCubit>()
                                    .fetchLoad(controller.text, "", null);
                              } */
                            }),
                          ),
                          const Divider(),
                          ElevatedButton(
                            onPressed: () {
                              /*  if (controller.text.trim().isNotEmpty) {
                                context
                                    .read<FilterTagLoadOrderCubit>()
                                    .fetchLoad(controller.text, "", null);
                              } */
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

                      // Filtrar pedidos baseado na busca
                      final filteredPedidos = data.pedidos.where((pedido) {
                        final query = searchQuery.toLowerCase();
                        return pedido.pedido.toLowerCase().contains(query) ||
                            pedido.nomeCliente.toLowerCase().contains(query);
                      }).toList();

                      return Column(
                        children: [
                          // Campo de busca
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                labelText: 'Buscar por pedido ou cliente...',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          searchController.clear();
                                          setState(() {
                                            searchQuery = '';
                                          });
                                        },
                                      )
                                    : null,
                                border: const OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                            ),
                          ),
                          // Contador de resultados
                          if (searchQuery.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    '${filteredPedidos.length} de ${data.pedidos.length} pedidos encontrados',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 8),
                          /*   Text(
                            "Carga ${data.carga}",
                            style: Theme.of(context).textTheme.displaySmall,
                          ), */
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredPedidos.length,
                              itemBuilder: (context, index) {
                                final pedido = filteredPedidos[index];
                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      final cubit = context
                                          .read<FilterTagLoadOrderCubit>();
                                      cubit.setSelectedInvoice(pedido);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FilterTagsOrderProductsPage(
                                            cubit: cubit,
                                            orderBydate: "0-$dateIni-$dateEnd",
                                          ),
                                        ),
                                      );
                                    },
                                    title: Text('Pedido: ${pedido.pedido}'),
                                    subtitle: Text(pedido.nomeCliente),
                                    trailing: pedido.hasTag()
                                        ? IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FilterTagsOrderPage(
                                                    pedido: pedido.pedido,
                                                  ),
                                                ),
                                              );
                                              //FilterTagsOrdesDateList
                                            },
                                            icon: FaIcon(
                                              FontAwesomeIcons.boxOpen,
                                              color: pedido.statusTags(),
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

  Future pickeDateRange(BuildContext ctx) async {
    final DateTimeRange dateRange =
        DateTimeRange(start: DateTime.now(), end: DateTime.now());

    final themeData = Theme.of(context);
    DateTimeRange? datePicked = await showDateRangePicker(
        context: context,
        initialDateRange: dateRange,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        builder: (context, Widget? child) => Theme(
              data: themeData.copyWith(
                datePickerTheme: const DatePickerThemeData(
                    rangeSelectionBackgroundColor: AppColors.background),
                appBarTheme: themeData.appBarTheme.copyWith(
                    backgroundColor: Colors.blue,
                    iconTheme: themeData.appBarTheme.iconTheme!
                        .copyWith(color: Colors.red)),
                colorScheme: const ColorScheme.light(
                  onPrimary: Colors.white,
                  primary: Colors.grey,
                  //surface: Colors.green,
                ),
              ),
              child: child!,
            ));

    if (datePicked == null) return;

    setState(() {
      dateIni = datetimeToYYYYMMDD(datePicked.start);
      dateEnd = datetimeToYYYYMMDD(datePicked.end);
    });
  }
}


/* 

SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<FilterTagLoadOrderCubit, FilterTagLoadOrderState>(
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
                              .fetchLoad(controller.text, "", null);
                        }
                      }),
                    ),
                    const Divider(),
                    ElevatedButton(
                      onPressed: () {
                        if (controller.text.trim().isNotEmpty) {
                          context
                              .read<FilterTagLoadOrderCubit>()
                              .fetchLoad(controller.text, "", null);
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
                                final cubit =
                                    context.read<FilterTagLoadOrderCubit>();
                                cubit.setSelectedInvoice(data.pedidos[index]);
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
                              title:
                                  Text('Pedido: ${data.pedidos[index].pedido}'),
                              subtitle: Text(data.pedidos[index].nomeCliente),
                              trailing: data.pedidos[index].hasTag()
                                  ? IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FilterTagsOrderPage(
                                              pedido:
                                                  data.pedidos[index].pedido,
                                            ),
                                          ),
                                        );
                                        //FilterTagsOrdesDateList
                                      },
                                      icon: FaIcon(
                                        FontAwesomeIcons.boxOpen,
                                        color: data.pedidos[index].statusTags(),
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
      
 */
