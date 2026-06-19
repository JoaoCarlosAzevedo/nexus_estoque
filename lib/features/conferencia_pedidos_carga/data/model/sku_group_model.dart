import 'package:nexus_estoque/features/order_check/data/model/order_check_model.dart';

import 'conferencia_pedido_model.dart';

class SkuGroup {
  final String codProduto;
  final String descProduto;
  final int quantidadeTotal;
  final int conferidoTotal;
  final bool isBlind;

  const SkuGroup({
    required this.codProduto,
    required this.descProduto,
    required this.quantidadeTotal,
    required this.conferidoTotal,
    required this.isBlind,
  });

  bool get isComplete => conferidoTotal == quantidadeTotal;
  bool get isPartial => conferidoTotal > 0 && conferidoTotal < quantidadeTotal;
  bool get isExcedente => conferidoTotal > quantidadeTotal;

  static List<SkuGroup> fromPedidos(List<ConferenciaPedidoModel> pedidos) {
    final map = <String, _SkuAccumulator>{};

    for (final pedido in pedidos) {
      for (final item in pedido.itens) {
        final cod = item.codProduto.trim();
        map.putIfAbsent(cod, () => _SkuAccumulator(cod)).add(item);
      }
    }

    return map.values
        .map((acc) => SkuGroup(
              codProduto: acc.codProduto,
              descProduto: acc.descProduto,
              quantidadeTotal: acc.quantidadeTotal,
              conferidoTotal: acc.conferidoTotal,
              isBlind: acc.isBlind,
            ))
        .toList()
      ..sort((a, b) => a.codProduto.compareTo(b.codProduto));
  }
}

class _SkuAccumulator {
  _SkuAccumulator(this.codProduto);

  final String codProduto;
  String descProduto = '';
  int quantidadeTotal = 0;
  int conferidoTotal = 0;
  bool isBlind = false;

  void add(OrderCheckItemModel item) {
    if (descProduto.isEmpty) descProduto = item.descProduto;
    isBlind = item.isBlind;
    quantidadeTotal += item.quantidade;
    conferidoTotal += item.conferido;
  }
}
