import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nexus_estoque/core/services/audio_player.dart';

import '../data/model/order_check_model.dart';

enum OrderCheckScanResult { success, notFound }

class OrderCheckScanFeedback {
  final String code;
  final OrderCheckScanResult result;
  final String? productName;
  final String? codProduto;
  final String? descProduto;
  final int totalConferido;
  final int totalQuantidade;
  final bool isBlind;

  const OrderCheckScanFeedback({
    required this.code,
    required this.result,
    this.productName,
    this.codProduto,
    this.descProduto,
    this.totalConferido = 0,
    this.totalQuantidade = 0,
    this.isBlind = false,
  });
}

class OrderCheckState {
  final List<OrderCheckItemModel> itens;
  final OrderCheckScanFeedback? lastScanFeedback;

  const OrderCheckState({
    required this.itens,
    this.lastScanFeedback,
  });

  OrderCheckState copyWith({
    List<OrderCheckItemModel>? itens,
    OrderCheckScanFeedback? lastScanFeedback,
  }) {
    return OrderCheckState(
      itens: itens ?? this.itens,
      lastScanFeedback: lastScanFeedback,
    );
  }
}

final orderCheckNotifierProvider = StateNotifierProvider.autoDispose
    .family<OrderCheckNotifier, OrderCheckState, OrderCheckModel>(
        (ref, pedido) {
  return OrderCheckNotifier().._init(pedido);
});

class OrderCheckNotifier extends StateNotifier<OrderCheckState> {
  OrderCheckNotifier() : super(const OrderCheckState(itens: []));

  void _init(OrderCheckModel pedido) {
    state = OrderCheckState(
      itens: List.from(pedido.itens),
      lastScanFeedback: null,
    );
  }

  void registrarConferencia(String code) {
    final trimmedCode = code.trim();
    if (trimmedCode.isEmpty) return;

    final itens = List<OrderCheckItemModel>.from(state.itens);

    // Encontra o índice do item a atualizar:
    // - Primeira linha com conferido < quantidade (distribui normalmente)
    // - Ou última linha do SKU (permite exceder quantidade do pedido)
    int? indexToUpdate;
    int? lastMatchIndex;

    for (int i = 0; i < itens.length; i++) {
      final item = itens[i];
      final codProduto = item.codProduto.trim();
      final barcode = item.barcode.trim();
      final barcode2 = item.barcode2.trim();
      final matches = codProduto.trim() == trimmedCode ||
          barcode.trim() == trimmedCode ||
          barcode2.trim() == trimmedCode;

      if (matches) {
        lastMatchIndex = i;
        if (item.conferido < item.quantidade) {
          indexToUpdate = i;
          break;
        }
      }
    }

    // Se todas as linhas já estão cheias, adiciona na última (permite exceder)
    if (indexToUpdate == null && lastMatchIndex != null) {
      indexToUpdate = lastMatchIndex;
    }

    if (indexToUpdate != null) {
      final item = itens[indexToUpdate];
      final matchedBarcode2 = item.barcode2.trim() == trimmedCode;
      final increment = (matchedBarcode2 && item.fator != 0)
          ? item.fator.round()
          : 1;
      itens[indexToUpdate] = item.copyWith(conferido: item.conferido + increment);
      final itensComSku =
          itens.where((i) => i.codProduto.trim() == item.codProduto.trim());
      final totalConf = itensComSku.fold<int>(0, (sum, i) => sum + i.conferido);
      final totalQtd = itensComSku.fold<int>(0, (sum, i) => sum + i.quantidade);
      state = state.copyWith(
        itens: itens,
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
    state = state.copyWith(lastScanFeedback: null);
  }

  void setConferidoQuantity(String codProduto, int newQuantity) {
    final trimmedCod = codProduto.trim();
    final itens = List<OrderCheckItemModel>.from(state.itens);
    final indices = <int>[];
    for (int i = 0; i < itens.length; i++) {
      if (itens[i].codProduto.trim() == trimmedCod) indices.add(i);
    }
    if (indices.isEmpty) return;

    var remaining = newQuantity;
    for (int j = 0; j < indices.length; j++) {
      final i = indices[j];
      final isLast = j == indices.length - 1;
      final qtd = itens[i].quantidade;
      final conferido = isLast
          ? remaining
          : (remaining >= qtd ? qtd : (remaining > 0 ? remaining : 0));
      remaining -= conferido;
      itens[i] = itens[i].copyWith(conferido: conferido);
    }

    state = state.copyWith(itens: itens);
  }
}
