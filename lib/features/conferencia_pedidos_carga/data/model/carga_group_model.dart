import 'conferencia_pedido_model.dart';

class CargaGroup {
  final String carga;
  final List<ConferenciaPedidoModel> pedidos;

  const CargaGroup({
    required this.carga,
    required this.pedidos,
  });

  int get totalPedidos => pedidos.length;

  int get totalItens =>
      pedidos.fold(0, (sum, pedido) => sum + pedido.itens.length);

  int get totalItensConferidos => pedidos.fold(
        0,
        (sum, pedido) =>
            sum +
            pedido.itens.where((i) => i.conferido == i.quantidade).length,
      );

  double get progressPercent =>
      totalItens == 0 ? 0 : totalItensConferidos / totalItens;

  static List<CargaGroup> fromPedidos(List<ConferenciaPedidoModel> pedidos) {
    final map = <String, List<ConferenciaPedidoModel>>{};
    for (final pedido in pedidos) {
      map.putIfAbsent(pedido.carga, () => []).add(pedido);
    }
    return map.entries
        .map((e) => CargaGroup(carga: e.key, pedidos: e.value))
        .toList()
      ..sort((a, b) => a.carga.compareTo(b.carga));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CargaGroup &&
          runtimeType == other.runtimeType &&
          carga == other.carga;

  @override
  int get hashCode => carga.hashCode;
}
