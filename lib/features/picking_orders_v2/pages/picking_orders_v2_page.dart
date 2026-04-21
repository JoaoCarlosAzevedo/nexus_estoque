import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../core/error/failure.dart';
import '../../../core/features/bluetooth_printer/bluetooth_printer.dart';
import '../../../core/services/bt_printer.dart';
import '../../picking_load_v2/data/model/pickingv2_model.dart';
import '../../volume_label/data/repositories/volume_label_repository.dart';

import '../data/model/picking_monitor_model.dart';
import '../data/repositories/picking_orders_v2_repository.dart';
import '../data/repositories/picking_user_monitor.dart';
import 'cubit/picking_orders_v2_cubit.dart';
import 'picking_orders_v2_products_page.dart';
import 'widgets/picking_status_widget.dart';

class _PrintOrderLabelConfirmDialog extends ConsumerStatefulWidget {
  const _PrintOrderLabelConfirmDialog({required this.pedido});

  final String pedido;

  @override
  ConsumerState<_PrintOrderLabelConfirmDialog> createState() =>
      _PrintOrderLabelConfirmDialogState();
}

class _PrintOrderLabelConfirmDialogState
    extends ConsumerState<_PrintOrderLabelConfirmDialog> {
  bool _loading = false;

  String _mensagemErro(Object e) {
    if (e is Failure) return e.error;
    return e.toString();
  }

  Future<void> _mostrarErro(String mensagem) async {
    if (!mounted) return;
    final theme = Theme.of(context);
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error_outline, color: theme.colorScheme.error),
              const SizedBox(width: 8),
              const Expanded(child: Text('Erro')),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              mensagem,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onConfirm() async {
    setState(() => _loading = true);
    try {
      final zpl =
          await ref.read(volumeLabelRepository).getOrderLabel(widget.pedido);
      if (!mounted) return;
      if (zpl.trim().isEmpty) {
        setState(() => _loading = false);
        await _mostrarErro(
          'Nenhuma etiqueta disponível para o pedido ${widget.pedido}.',
        );
        return;
      }
      final ok = await BluetoothPrinter.printZPL(zpl);
      if (!mounted) return;
      if (!ok) {
        setState(() => _loading = false);
        await _mostrarErro(
          'Não foi possível imprimir a etiqueta. Verifique a conexão Bluetooth com a impressora.',
        );
        if (mounted) await BluetoothPageModal.show(context);
        return;
      }
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      await _mostrarErro(_mensagemErro(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    final maxDialogHeight = mq.size.height * 0.85;
    const actionsBarMinHeight = 72.0;
    final scrollMaxHeight = math.max(
      120.0,
      maxDialogHeight - actionsBarMinHeight - mq.padding.vertical,
    );

    return PopScope(
      canPop: !_loading,
      child: Dialog(
        clipBehavior: Clip.antiAlias,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: math.min(420, mq.size.width - 40),
            maxHeight: maxDialogHeight,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: scrollMaxHeight),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Imprimir etiqueta',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Deseja imprimir a etiqueta do pedido ${widget.pedido} via Bluetooth?',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              Material(
                color: theme.colorScheme.surfaceContainerHighest,
                child: SafeArea(
                  top: false,
                  minimum: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onPressed: _loading
                              ? null
                              : () => Navigator.of(context, rootNavigator: true)
                                  .pop(),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          onPressed: _loading ? null : _onConfirm,
                          child: _loading
                              ? const SizedBox(
                                  key: Key('loading_button'),
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.green,
                                  ),
                                )
                              : const Text(
                                  'Confirmar',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  /// Pedido da [PickingOrdersV2ProductsPage] aberta a partir desta listagem
  /// (modo não-monitor: [PickingOrdersV2ListWidget.order] vem vazio).
  String? _activePickingOrder;

  /// Pedidos que tinham `lEtiqPed` na última resposta de [fetchOrdersV2].
  Set<String>? _pedidosComEtiqSnapshot;

  Future<void> _openPickingProductsPage(
    BuildContext context,
    PickingOrdersV2Cubit cubit,
    String pedido,
  ) async {
    final trimmed = pedido.trim();
    setState(() => _activePickingOrder = trimmed);
    try {
      await Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (context) => PickingOrdersV2ProductsPage(
            cubit: cubit,
            order: trimmed,
          ),
        ),
      );
    } finally {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _activePickingOrder = null);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handlePickingLoadsUpdated(List<Pickingv2Model> loads) {
    final currentPedidos = loads.map((e) => e.pedido.trim()).toSet();
    final pedidosComEtiq = <String>{};
    for (final e in loads) {
      if (e.lEtiqPed) {
        pedidosComEtiq.add(e.pedido.trim());
      }
    }

    final focusedOrder =
        (_activePickingOrder ?? widget.order).trim();
    if (focusedOrder.isEmpty) {
      _pedidosComEtiqSnapshot = pedidosComEtiq;
      return;
    }

    final snapshotAnterior = _pedidosComEtiqSnapshot;
    if (snapshotAnterior != null) {
      final finalizadaMonitor = !currentPedidos.contains(focusedOrder) &&
          snapshotAnterior.contains(focusedOrder);
      final pedidosParaDialog =
          finalizadaMonitor ? [focusedOrder] : const <String>[];

      if (pedidosParaDialog.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _runEtiqPrintDialogs(pedidosParaDialog);
        });
      }
    }
    _pedidosComEtiqSnapshot = pedidosComEtiq;
  }

  Future<void> _runEtiqPrintDialogs(List<String> pedidos) async {
    for (final pedido in pedidos) {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (ctx) => _PrintOrderLabelConfirmDialog(pedido: pedido),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    late List<Pickingv2Model> orders;
    return BlocProvider(
      create: (context) =>
          PickingOrdersV2Cubit(ref.read(pickingOrdersV2RepositoryProvider)),
      child: BlocListener<PickingOrdersV2Cubit, PickingOrdersV2State>(
        listenWhen: (previous, current) => current is PickingOrdersV2Loaded,
        listener: (context, state) {
          if (state is PickingOrdersV2Loaded) {
            _handlePickingLoadsUpdated(state.loads);
          }
        },
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
                          //_runEtiqPrintDialogs(['1234567890']);
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
                  child: Column(
                    children: [
                      // Campo de busca
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Buscar pedido...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.toLowerCase();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: BlocBuilder<PickingOrdersV2Cubit,
                            PickingOrdersV2State>(
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
                                        order.pedido.trim() ==
                                        widget.order.trim())
                                    .toList(); // Convert the Iterable result back to a List
                              } else {
                                if (widget.monitor != null) {
                                  // Filtrar pedidos que não existem no array iniciados
                                  final initiatedOrders = widget
                                      .monitor!.iniciados
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

                              // Aplicar filtro de busca se houver texto na busca
                              if (_searchQuery.isNotEmpty) {
                                orders = orders
                                    .where((order) => order.pedido
                                        .toLowerCase()
                                        .contains(_searchQuery))
                                    .toList();
                              }

                              // Ordenar: pedidos com retira preenchido no topo, depois por número do pedido
                              orders.sort((a, b) {
                                final aRetiraPreenchido =
                                    a.retira.trim().isNotEmpty;
                                final bRetiraPreenchido =
                                    b.retira.trim().isNotEmpty;
                                if (aRetiraPreenchido != bRetiraPreenchido) {
                                  return (bRetiraPreenchido ? 1 : 0)
                                      .compareTo(aRetiraPreenchido ? 1 : 0);
                                }
                                return a.pedido.compareTo(b.pedido);
                              });

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
                                      separationStatus:
                                          widget.order.trim().isEmpty
                                              ? 'Disponível para nova separação'
                                              : 'Em processo de separação',
                                    ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GroupedListView<Pickingv2Model,
                                          String>(
                                        elements: orders.toList(),
                                        groupBy: (element) =>
                                            '${element.retira.trim().isEmpty ? '1' : '0'}_${element.pedido}',
                                        groupSeparatorBuilder:
                                            (String groupByValue) {
                                          final pedido = groupByValue
                                                  .contains('_')
                                              ? groupByValue.substring(
                                                  groupByValue.indexOf('_') + 1)
                                              : groupByValue;
                                          final qtdProd = orders
                                              .where(
                                                (element) =>
                                                    element.pedido.trim() ==
                                                    pedido,
                                              )
                                              .toList();
                                          final isFaturado = qtdProd.any(
                                              (element) =>
                                                  element.status.trim() ==
                                                  "Faturado");
                                          return GestureDetector(
                                            onTap: () async {
                                              if (widget.isMonitor &&
                                                  widget.order.isEmpty) {
                                                // Mostrar diálogo de confirmação para iniciar separação
                                                showDialog<bool>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Iniciar Separação'),
                                                      content: Text(
                                                          'Deseja iniciar a separação do pedido $pedido?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false);
                                                          },
                                                          child: const Text(
                                                              'Cancelar'),
                                                        ),
                                                        Consumer(
                                                          builder: (context,
                                                              ref, child) {
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
                                                                  child: CircularProgressIndicator(
                                                                      strokeWidth:
                                                                          2),
                                                                ),
                                                              ),
                                                              error: (error,
                                                                  stackTrace) {
                                                                return Text(
                                                                  error
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                );
                                                              },
                                                              data: (data) {
                                                                if (mounted) {
                                                                  if (data) {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            true);
                                                                  }
                                                                }
                                                                return ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    ref
                                                                        .read(postStartPickingProvider
                                                                            .notifier)
                                                                        .postInitPicking(
                                                                            pedido);
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
                                                ).then((confirmStart) async {
                                                  if (confirmStart == true) {
                                                    final cubit = context.read<
                                                        PickingOrdersV2Cubit>();
                                                    await _openPickingProductsPage(
                                                      context,
                                                      cubit,
                                                      pedido,
                                                    );
                                                  }
                                                });
                                              } else {
                                                final cubit = context.read<
                                                    PickingOrdersV2Cubit>();
                                                await _openPickingProductsPage(
                                                  context,
                                                  cubit,
                                                  pedido,
                                                );
                                              }
                                            },
                                            child: Card(
                                              child: ListTile(
                                                title: Wrap(
                                                  children: [
                                                    Text("Pedido $pedido"),
                                                    if (isFaturado) ...[
                                                      const SizedBox(width: 8),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: const Text(
                                                          'FATURADO',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                    const SizedBox(width: 8),
                                                    if (qtdProd.first.retira
                                                        .isNotEmpty)
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: const Text(
                                                          'RETIRA',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (qtdProd.isNotEmpty)
                                                      Text(
                                                          qtdProd.first.desCli),
                                                    Text(
                                                        "Qtd. Itens ${qtdProd.length}"),
                                                  ],
                                                ),
                                                trailing: const FaIcon(
                                                    FontAwesomeIcons
                                                        .clipboardCheck),
                                              ),
                                            ),
                                          );
                                        },
                                        itemBuilder: (context, element) {
                                          return Container();
                                        },
                                        itemComparator: (item1, item2) =>
                                            item1.pedido.compareTo(
                                                item2.pedido), // optional
                                        useStickyGroupSeparators:
                                            false, // optional
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
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
