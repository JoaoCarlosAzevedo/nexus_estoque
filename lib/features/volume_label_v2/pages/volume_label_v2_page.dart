import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:nexus_estoque/core/theme/app_colors.dart';

import '../../../../core/utils/datetime_formatter.dart';
import '../../filter_tags_orders/data/model/filter_tag_load_order_model.dart';
import '../../filter_tags_orders/data/repositories/filter_tag_order_repository.dart';
import '../../filter_tags_orders/pages/filter_tags_order_load_page/cubit/filter_tag_order_load_cubit.dart';
import '../../picking_orders_v2/pages/volume_order_products_page.dart';
import 'volume_label_v2_order_page.dart';

class VolumeLabelV2Page extends ConsumerStatefulWidget {
  const VolumeLabelV2Page({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VolumeLabelV2PageState();
}

class _VolumeLabelV2PageState extends ConsumerState<VolumeLabelV2Page> {
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
          ref.read(filterTagRepositoryProvider),
          "0-$dateIni-$dateEnd-etiqueta_individual"),
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
                      context.read<FilterTagLoadOrderCubit>().fetchLoad(
                          "0-$dateIni-$dateEnd-etiqueta_individual", "", null);
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
                                      _showOrderVolumesDialog(
                                          context, pedido.pedido, pedido);
                                    },
                                    title: Text('Pedido: ${pedido.pedido}'),
                                    subtitle: Text(pedido.nomeCliente),
                                    trailing: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VolumeLabelV2OrderPage(
                                              order: pedido,
                                            ),
                                          ),
                                        );
                                        //FilterTagsOrdesDateList
                                      },
                                      icon: const FaIcon(
                                        FontAwesomeIcons.print,
                                        //color: Colors.blue,
                                      ),
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

  void _showOrderVolumesDialog(
      BuildContext context, String pedido, Orders order) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pedido: $pedido',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final orderVolumesAsync =
                        ref.watch(orderVolumesProvider(pedido));

                    return orderVolumesAsync.when(
                      data: (order) {
                        // Fecha o modal e retorna os dados
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context).pop(order);
                        });

                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stack) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Erro: $error'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Fechar'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((result) {
      // Navega para FilterTagsOrderProductsPage após receber os dados
      if (result != null) {
        final cubit = context.read<FilterTagLoadOrderCubit>();
        final etiqOrder = result as Orders;

        if (etiqOrder.itens.isEmpty) {
          cubit.setSelectedInvoice(order);
        } else {
          // Soma as quantidades dos itens da etiqOrder agrupando por código
          final Map<String, double> quantitiesByCode = {};
          for (final item in etiqOrder.itens) {
            quantitiesByCode[item.codigo] =
                (quantitiesByCode[item.codigo] ?? 0) + item.quantidade;
          }

          // Busca os códigos na variável order e atualiza quantidaetiqueta
          for (final orderItem in order.itens) {
            if (quantitiesByCode.containsKey(orderItem.codigo)) {
              orderItem.quantidaetiqueta = quantitiesByCode[orderItem.codigo]!;
            }
          }

          cubit.setSelectedInvoice(order);
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VolumeOrderProductsPage(
              cubit: cubit,
              orderBydate: "0-$dateIni-$dateEnd",
            ),
          ),
        );
      }
    });
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
