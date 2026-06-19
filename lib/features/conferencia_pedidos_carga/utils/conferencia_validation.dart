import '../data/model/conferencia_pedido_model.dart';

class ConferenciaInconsistencia {
  final String pedido;
  final String cliente;
  final String codProduto;
  final String descProduto;
  final int quantidade;
  final int conferido;

  const ConferenciaInconsistencia({
    required this.pedido,
    required this.cliente,
    required this.codProduto,
    required this.descProduto,
    required this.quantidade,
    required this.conferido,
  });

  int get diferenca => conferido - quantidade;
}

List<ConferenciaInconsistencia> findInconsistencias(
  List<ConferenciaPedidoModel> pedidos,
) {
  final result = <ConferenciaInconsistencia>[];

  for (final pedido in pedidos) {
    for (final item in pedido.itens) {
      if (item.conferido != item.quantidade) {
        result.add(
          ConferenciaInconsistencia(
            pedido: pedido.pedido,
            cliente: pedido.cliente,
            codProduto: item.codProduto,
            descProduto: item.descProduto,
            quantidade: item.quantidade,
            conferido: item.conferido,
          ),
        );
      }
    }
  }

  return result;
}
