import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../picking_load_v2/data/model/pickingv2_model.dart';

import '../data/model/picking_monitor_model.dart';
import '../data/repositories/picking_orders_v2_repository.dart';
import '../data/repositories/picking_user_monitor.dart';
import 'cubit/picking_orders_v2_cubit.dart';
import 'picking_orders_v2_products_page.dart';
import 'widgets/picking_status_widget.dart';

class PickingOrdersV2List extends ConsumerStatefulWidget {
  const PickingOrdersV2List({super.key, required this.isMonitor});
  final bool isMonitor;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PickingOrdersV2ListState();
}

class _PickingOrdersV2ListState extends ConsumerState<PickingOrdersV2List> {
  bool filterFaturado = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isMonitor) {
      final provider = ref.watch(fetchUserMonitorProvider);
      return provider.when(
          skipLoadingOnRefresh: false,
          data: (data) {
            return PickingOrdersV2ListWidget(
              order: data.chave.trim(),
              isMonitor: true,
              monitor: data,
            );
          },
          error: (error, stackTrace) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Pedidos"),
                actions: [
                  IconButton(
                      onPressed: () {
                        ref.invalidate(fetchUserMonitorProvider);
                      },
                      icon: const Icon(Icons.refresh)),
                ],
              ),
              body: Center(
                child: Text(error.toString()),
              ),
            );
          },
          loading: () {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Pedidos"),
                actions: [
                  IconButton(
                      onPressed: () {
                        ref.invalidate(fetchUserMonitorProvider);
                      },
                      icon: const Icon(Icons.refresh)),
                ],
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          });
    } else {
      return const PickingOrdersV2ListWidget(
        order: '',
        isMonitor: false,
        monitor: null,
      );
    }
  }
}

class PickingOrdersV2ListWidget extends ConsumerStatefulWidget {
  const PickingOrdersV2ListWidget(
      {super.key,
      required this.order,
      required this.isMonitor,
      required this.monitor});
  final String order;
  final bool isMonitor;
  final PickingMonitorModel? monitor;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PickingOrdersV2ListWidgetState();
}

class _PickingOrdersV2ListWidgetState
    extends ConsumerState<PickingOrdersV2ListWidget> {
  bool filterFaturado = false;

  @override
  Widget build(BuildContext context) {
    late List<Pickingv2Model> orders;
    return BlocProvider(
      create: (context) =>
          PickingOrdersV2Cubit(ref.read(pickingOrdersV2RepositoryProvider)),
      child: BlocBuilder<PickingOrdersV2Cubit, PickingOrdersV2State>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Pedidos"),
              actions: [
                IconButton(
                    onPressed: () {
                      if (widget.isMonitor) {
                        ref.invalidate(fetchUserMonitorProvider);
                      } else {
                        context
                            .read<PickingOrdersV2Cubit>()
                            .fetchPickingOrdersv2();
                      }
                    },
                    icon: const Icon(Icons.refresh)),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<PickingOrdersV2Cubit, PickingOrdersV2State>(
                  builder: (context, state) {
                    if (state is PickingOrdersV2Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is PickingOrdersV2Error) {
                      return Center(
                        child: Text(state.error.error),
                      );
                    }

                    if (state is PickingOrdersV2Loaded) {
                      List<Pickingv2Model> data = state.loads;

                      if (widget.order.isNotEmpty) {
                        orders = data
                            .where((order) =>
                                order.pedido.trim() == widget.order.trim())
                            .toList(); // Convert the Iterable result back to a List
                      } else {
                        if (widget.monitor != null) {
                          // Filtrar pedidos que não existem no array iniciados
                          final initiatedOrders = widget.monitor!.iniciados
                              .map((item) => item.chave.trim())
                              .toSet();

                          orders = data
                              .where((order) => !initiatedOrders
                                  .contains(order.pedido.trim()))
                              .toList();
                        } else {
                          orders = data;
                        }
                      }
                      if (!widget.isMonitor) {
                        if (orders.isEmpty) {
                          return const Center(
                            child: Text("Nenhum registro encontrado."),
                          );
                        }
                      }

                      return Column(
                        children: [
                          if (widget.isMonitor)
                            PickingStatusWidget(
                              orderNumber: widget.order,
                              separationStatus: widget.order.trim().isEmpty
                                  ? 'Disponível para nova separação'
                                  : 'Em processo de separação',
                            ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GroupedListView<Pickingv2Model, String>(
                                elements: orders.toList(),
                                groupBy: (element) => element.pedido,
                                groupSeparatorBuilder: (String groupByValue) {
                                  final qtdProd = orders
                                      .where(
                                        (element) =>
                                            element.pedido.trim() ==
                                            groupByValue,
                                      )
                                      .toList();
                                  return GestureDetector(
                                    onTap: () async {
                                      if (widget.isMonitor &&
                                          widget.order.isEmpty) {
                                        // Mostrar diálogo de confirmação para iniciar separação
                                        final bool? confirmStart =
                                            await showDialog<bool>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Iniciar Separação'),
                                              content: Text(
                                                  'Deseja iniciar a separação do pedido $groupByValue?'),
                                              actions: [
                                                Consumer(
                                                  builder:
                                                      (context, ref, child) {
                                                    final startPickingState =
                                                        ref.watch(
                                                            postStartPickingProvider);
                                                    return startPickingState
                                                        .when(
                                                      loading: () =>
                                                          const ElevatedButton(
                                                        onPressed: null,
                                                        child: SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2),
                                                        ),
                                                      ),
                                                      error:
                                                          (error, stackTrace) {
                                                        return Text(
                                                          error.toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                        );
                                                      },
                                                      data: (data) {
                                                        if (mounted) {
                                                          if (data) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(true);
                                                          }
                                                        }
                                                        return ElevatedButton(
                                                          onPressed: () async {
                                                            await ref
                                                                .read(postStartPickingProvider
                                                                    .notifier)
                                                                .postInitPicking(
                                                                    groupByValue);
                                                          },
                                                          child: const Text(
                                                              'Confirmar'),
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (confirmStart == true) {
                                          // Atualizar o monitor e navegar para a próxima tela
                                          final cubit = context
                                              .read<PickingOrdersV2Cubit>();

                                          // Navegar primeiro, depois invalidar o provider
                                          final bool? isFinished =
                                              await Navigator.push(
                                            // ignore: use_build_context_synchronously
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PickingOrdersV2ProductsPage(
                                                cubit: cubit,
                                                order: groupByValue,
                                              ),
                                            ),
                                          ).then((_) {
                                            // Invalidar o provider após a navegação
                                            ref.invalidate(
                                                fetchUserMonitorProvider);
                                          });

                                          if (widget.isMonitor) {
                                            // Verificar se a separação foi finalizada
                                            if (isFinished == true) {
                                              // Atualizar o monitor após todas as operações
                                              if (mounted) {
                                                ref.invalidate(
                                                    fetchUserMonitorProvider);
                                              }
                                            }
                                          }
                                        }
                                      } else {
                                        final cubit = context
                                            .read<PickingOrdersV2Cubit>();
                                        final bool? isFinished =
                                            await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PickingOrdersV2ProductsPage(
                                              cubit: cubit,
                                              order: groupByValue,
                                            ),
                                          ),
                                        );
                                        if (widget.isMonitor) {
                                          // Verificar se a separação foi finalizada
                                          if (isFinished == true) {
                                            if (mounted) {
                                              ref.invalidate(
                                                  fetchUserMonitorProvider);
                                            }
                                          }
                                        }
                                      }
                                    },
                                    child: Card(
                                      child: ListTile(
                                        title: Text("Pedido $groupByValue"),
                                        subtitle: Text(
                                            "Qtd. Itens ${qtdProd.length}"),
                                        trailing: const FaIcon(
                                            FontAwesomeIcons.clipboardCheck),
                                      ),
                                    ),
                                  );
                                },
                                itemBuilder: (context, element) {
                                  return Container();
                                },
                                itemComparator: (item1, item2) => item1.pedido
                                    .compareTo(item2.pedido), // optional
                                useStickyGroupSeparators: false, // optional
                                floatingHeader: false, // optional
                                order: GroupedListOrder.ASC, // optional
                              ),
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
