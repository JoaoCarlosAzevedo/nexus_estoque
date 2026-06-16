import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:nexus_estoque/core/theme/app_theme.dart';

import '../../picking_load_v2/data/model/pickingv2_model.dart';
import '../../picking_load_v2/data/repositories/pickingv2_repository.dart';
import '../../picking_load_v2/pages/picking_form_v2_page/picking_form_v3_modal.dart';
import '../../picking_load_v2/pages/picking_load_produts_list_page/widgets/picking_product_card_v2.dart';
import 'cubit/picking_orders_v2_cubit.dart';
import 'widgets/checkout_label_modal.dart';

class PickingOrdersV2ProductsPage extends ConsumerStatefulWidget {
  const PickingOrdersV2ProductsPage({
    required this.cubit,
    required this.order,
    super.key,
  });

  final String order;
  final PickingOrdersV2Cubit cubit;

  @override
  ConsumerState<PickingOrdersV2ProductsPage> createState() =>
      _PickingOrdersV2ProductsPageState();
}

class _PickingOrdersV2ProductsPageState
    extends ConsumerState<PickingOrdersV2ProductsPage> {
  bool _checkoutTriggered = false;
  bool _checkoutDone = false;
  bool _isPosting = false;

  /// Indica se o pedido em questao exige etiqueta de checkout, capturado
  /// enquanto o pedido ainda esta presente no retorno da API. Quando o
  /// pedido sai do estado, ja nao temos como ler [letiqCheckout] do item,
  /// entao mantemos o ultimo valor conhecido aqui.
  bool _orderRequiresCheckout = false;

  @override
  void initState() {
    super.initState();
    // BlocListener so dispara em emissoes novas. Se o cubit ja esta em
    // Loaded ao montar a pagina, capturamos letiqCheckout do estado
    // atual para nao perder o valor antes da primeira nova emissao.
    _captureOrderRequiresCheckout(widget.cubit.state);
  }

  /// Considera a separacao finalizada quando o pedido nao aparece mais
  /// no retorno do PickingOrdersV2Cubit (API).
  bool _isOrderFinalizedInState(PickingOrdersV2Loaded state) {
    return !state.loads.any((e) => e.pedido.trim() == widget.order);
  }

  void _captureOrderRequiresCheckout(PickingOrdersV2State state) {
    if (state is! PickingOrdersV2Loaded) return;
    if (_isOrderFinalizedInState(state)) return;
    _orderRequiresCheckout = state.loads
        .where((e) => e.pedido.trim() == widget.order)
        .any((e) => e.letiqCheckout);
  }

  /// Recarrega a lista do cubit e volta para a pagina anterior.
  /// Usado quando o pedido foi finalizado mas nao precisa exibir o
  /// dialogo de checkout, ou quando o usuario cancela o dialogo.
  void _popAndRefresh() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.cubit.fetchPickingOrdersv2();
      if (!mounted) return;
      context.pop();
    });
  }

  void _handleCheckoutFlow() {
    if (_checkoutTriggered || _checkoutDone) return;
    // Apenas exibe o dialogo se o pedido exigir etiqueta de checkout
    // (letiqCheckout == true em algum item do pedido). Caso contrario,
    // marca como done, recarrega a lista e volta para a pagina anterior.
    if (!_orderRequiresCheckout) {
      _checkoutDone = true;
      _popAndRefresh();
      return;
    }
    _checkoutTriggered = true;

    // Adia o show do dialog para fora do callback do BlocListener,
    // evitando empilhar uma rota durante a propagacao do estado do
    // cubit (evita Null check operator no Navigator).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
      if (!isCurrent) {
        _checkoutTriggered = false;
        return;
      }

      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.bottomSlide,
        title: 'Separação concluída',
        desc:
            'Todos os itens do pedido ${widget.order} foram separados. Deseja iniciar o checkout?',
        btnCancelText: 'Cancelar',
        btnOkText: 'Iniciar',
        btnCancelColor: Colors.red,
        btnCancelOnPress: () {
          if (!mounted) return;
          _checkoutTriggered = false;
          _checkoutDone = true;
          _popAndRefresh();
        },
        btnOkOnPress: () {
          if (!mounted) return;
          _openLabelModal();
        },
        btnOkColor: Theme.of(context).primaryColor,
      ).show();
    });
  }

  Future<void> _openLabelModal() async {
    final etiqueta = await CheckoutLabelModal.show(context, widget.order);
    if (!mounted) return;

    if (etiqueta == null || etiqueta.isEmpty) {
      setState(() => _checkoutTriggered = false);
      return;
    }

    await _postCheckout(etiqueta);
  }

  Future<void> _postCheckout(String etiqueta) async {
    setState(() => _isPosting = true);

    final result = await ref
        .read(pickingv2RepositoryProvider)
        .postCheckout(widget.order, etiqueta);

    if (!mounted) return;
    setState(() => _isPosting = false);

    result.fold(
      (failure) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Erro no checkout',
          desc: failure.error,
          btnOkOnPress: () {},
          btnOkColor: Theme.of(context).primaryColor,
        ).show();
        setState(() => _checkoutTriggered = false);
      },
      (_) {
        setState(() => _checkoutDone = true);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: 'Checkout realizado',
          desc:
              'Etiqueta $etiqueta vinculada ao pedido ${widget.order} com sucesso.',
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: false,
          btnOkOnPress: () {
            widget.cubit.fetchPickingOrdersv2();
            if (mounted) {
              context.pop();
            }
          },
          btnOkColor: Theme.of(context).primaryColor,
        ).show();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    late List<Pickingv2Model> products;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("Pedido: ${widget.order}"),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                widget.cubit.fetchPickingOrdersv2();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: BlocProvider.value(
        value: widget.cubit,
        child: BlocListener<PickingOrdersV2Cubit, PickingOrdersV2State>(
          listener: (context, state) {
            if (state is PickingOrdersV2Loaded) {
              // Enquanto o pedido ainda aparece no retorno, captura o
              // letiqCheckout para usar quando ele desaparecer.
              _captureOrderRequiresCheckout(state);

              if (_isOrderFinalizedInState(state) &&
                  !_checkoutTriggered &&
                  !_checkoutDone) {
                _handleCheckoutFlow();
              }
            }
          },
          child: Stack(
            children: [
              BlocBuilder<PickingOrdersV2Cubit, PickingOrdersV2State>(
                builder: (context, state) {
                  if (state is PickingOrdersV2Loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is PickingOrdersV2Error) {
                    return Center(
                      child: Text("Erro: ${state.error.error}"),
                    );
                  }

                  if (state is PickingOrdersV2Loaded) {
                    if (state.loads.isEmpty) {
                      return const Center(
                        child: Text("Nenhum registro encontrado!"),
                      );
                    }
                    products = state.loads
                        .where((e) => e.pedido.trim() == widget.order)
                        .toList();

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GroupedListView<Pickingv2Model, String>(
                        elements: products,
                        groupBy: (element) => element.descEndereco2,
                        groupSeparatorBuilder: (String groupByValue) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 14),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  groupByValue,
                                  style: AppTheme.customTextTheme().titleLarge,
                                ),
                              ],
                            ),
                          );
                        },
                        itemBuilder: (context, Pickingv2Model element) {
                          return PickingProductCardv2(
                            data: element,
                            onTap: () async {
                              final result = await PickingFormv3Modal.show(
                                  context, element);
                              if (result == "ok") {
                                widget.cubit.fetchPickingOrdersv2();
                              }
                            },
                          );
                        },
                        itemComparator: (item1, item2) => item1.descEndereco2
                            .compareTo(item2.descEndereco2),
                        useStickyGroupSeparators: false,
                        floatingHeader: false,
                        order: GroupedListOrder.ASC,
                      ),
                    );
                  }
                  return const Center(
                    child: Text("Bad state!"),
                  );
                },
              ),
              if (_isPosting)
                const Positioned.fill(
                  child: ColoredBox(
                    color: Color(0x80000000),
                    child: Center(
                      child: CircularProgressIndicator(),
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
