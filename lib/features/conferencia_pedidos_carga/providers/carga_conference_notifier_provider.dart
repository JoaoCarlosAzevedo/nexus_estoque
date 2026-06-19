import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/services/audio_player.dart';
import 'package:nexus_estoque/features/order_check/data/model/order_check_model.dart';
import 'package:nexus_estoque/features/order_check/providers/order_check_notifier_provider.dart';

import '../data/model/carga_group_model.dart';
import '../data/model/conferencia_pedido_model.dart';
import '../data/model/sku_group_model.dart';

class CargaConferenceState {
  final String carga;
  final List<ConferenciaPedidoModel> pedidos;
  final OrderCheckScanFeedback? lastScanFeedback;

  const CargaConferenceState({
    required this.carga,
    required this.pedidos,
    this.lastScanFeedback,
  });

  List<SkuGroup> get skuGroups => SkuGroup.fromPedidos(pedidos);

  bool get isConferenciaCompleta {
    for (final pedido in pedidos) {
      for (final item in pedido.itens) {
        if (item.conferido != item.quantidade) return false;
      }
    }
    return pedidos.isNotEmpty;
  }

  CargaConferenceState copyWith({
    String? carga,
    List<ConferenciaPedidoModel>? pedidos,
    OrderCheckScanFeedback? lastScanFeedback,
    bool clearFeedback = false,
  }) {
    return CargaConferenceState(
      carga: carga ?? this.carga,
      pedidos: pedidos ?? this.pedidos,
      lastScanFeedback:
          clearFeedback ? null : (lastScanFeedback ?? this.lastScanFeedback),
    );
  }
}

final cargaConferenceNotifierProvider = StateNotifierProvider.autoDispose
    .family<CargaConferenceNotifier, CargaConferenceState, CargaGroup>(
        (ref, cargaGroup) {
  return CargaConferenceNotifier().._init(cargaGroup);
});

class CargaConferenceNotifier extends StateNotifier<CargaConferenceState> {
  CargaConferenceNotifier()
      : super(const CargaConferenceState(carga: '', pedidos: []));

  void _init(CargaGroup cargaGroup) {
    state = CargaConferenceState(
      carga: cargaGroup.carga,
      pedidos: cargaGroup.pedidos
          .map(
            (p) => p.copyWith(
              itens: p.itens.map((i) => i.copyWith()).toList(),
            ),
          )
          .toList(),
      lastScanFeedback: null,
    );
  }

  void registrarConferencia(String code) {
    final trimmedCode = code.trim();
    if (trimmedCode.isEmpty) return;

    final pedidos = _copyPedidos(state.pedidos);
    int? pedidoIndexToUpdate;
    int? itemIndexToUpdate;
    int? lastPedidoMatch;
    int? lastItemMatch;

    for (int pi = 0; pi < pedidos.length; pi++) {
      final itens = pedidos[pi].itens;
      for (int ii = 0; ii < itens.length; ii++) {
        final item = itens[ii];
        final matches = item.codProduto.trim() == trimmedCode ||
            item.barcode.trim() == trimmedCode ||
            item.barcode2.trim() == trimmedCode;

        if (matches) {
          lastPedidoMatch = pi;
          lastItemMatch = ii;
          if (item.conferido < item.quantidade) {
            pedidoIndexToUpdate = pi;
            itemIndexToUpdate = ii;
            break;
          }
        }
      }
      if (pedidoIndexToUpdate != null) break;
    }

    if (pedidoIndexToUpdate == null &&
        lastPedidoMatch != null &&
        lastItemMatch != null) {
      pedidoIndexToUpdate = lastPedidoMatch;
      itemIndexToUpdate = lastItemMatch;
    }

    if (pedidoIndexToUpdate != null && itemIndexToUpdate != null) {
      final pedido = pedidos[pedidoIndexToUpdate];
      final itens = List<OrderCheckItemModel>.from(pedido.itens);
      final item = itens[itemIndexToUpdate];
      final matchedBarcode2 = item.barcode2.trim() == trimmedCode;
      final increment =
          (matchedBarcode2 && item.fator != 0) ? item.fator.round() : 1;
      itens[itemIndexToUpdate] =
          item.copyWith(conferido: item.conferido + increment);
      pedidos[pedidoIndexToUpdate] = pedido.copyWith(itens: itens);

      final codProduto = item.codProduto.trim();
      var totalConf = 0;
      var totalQtd = 0;
      for (final p in pedidos) {
        for (final i in p.itens) {
          if (i.codProduto.trim() == codProduto) {
            totalConf += i.conferido;
            totalQtd += i.quantidade;
          }
        }
      }

      state = state.copyWith(
        pedidos: pedidos,
        lastScanFeedback: OrderCheckScanFeedback(
          code: trimmedCode,
          result: OrderCheckScanResult.success,
          codProduto: item.codProduto,
          descProduto: item.descProduto,
          totalConferido: totalConf,
          totalQuantidade: totalQtd,
          isBlind: item.isBlind,
        ),
      );
      AudioService.beep();
    } else {
      state = state.copyWith(
        lastScanFeedback: OrderCheckScanFeedback(
          code: trimmedCode,
          result: OrderCheckScanResult.notFound,
        ),
      );
      AudioService.error();
    }
  }

  void clearFeedback() {
    state = state.copyWith(clearFeedback: true);
  }

  void setConferidoQuantity(String codProduto, int newQuantity) {
    final trimmedCod = codProduto.trim();
    final pedidos = _copyPedidos(state.pedidos);
    final lineRefs = <_LineRef>[];

    for (int pi = 0; pi < pedidos.length; pi++) {
      for (int ii = 0; ii < pedidos[pi].itens.length; ii++) {
        if (pedidos[pi].itens[ii].codProduto.trim() == trimmedCod) {
          lineRefs.add(_LineRef(pi, ii));
        }
      }
    }
    if (lineRefs.isEmpty) return;

    var remaining = newQuantity;
    for (int j = 0; j < lineRefs.length; j++) {
      final ref = lineRefs[j];
      final isLast = j == lineRefs.length - 1;
      final pedido = pedidos[ref.pedidoIndex];
      final itens = List<OrderCheckItemModel>.from(pedido.itens);
      final qtd = itens[ref.itemIndex].quantidade;
      final conferido = isLast
          ? remaining
          : (remaining >= qtd ? qtd : (remaining > 0 ? remaining : 0));
      remaining -= conferido;
      itens[ref.itemIndex] =
          itens[ref.itemIndex].copyWith(conferido: conferido);
      pedidos[ref.pedidoIndex] = pedido.copyWith(itens: itens);
    }

    state = state.copyWith(pedidos: pedidos);
  }

  List<ConferenciaPedidoModel> _copyPedidos(
      List<ConferenciaPedidoModel> pedidos) {
    return pedidos
        .map(
          (p) => p.copyWith(
            itens: p.itens.map((i) => i.copyWith()).toList(),
          ),
        )
        .toList();
  }
}

class _LineRef {
  const _LineRef(this.pedidoIndex, this.itemIndex);

  final int pedidoIndex;
  final int itemIndex;
}
