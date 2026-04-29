import 'filter_tag_load_order_model.dart';
import 'filter_tag_order_model.dart';

class EtiquetaFiltroPedidoCompleto {
  final LoadOrder pedido;
  final List<FilterTagOrderModel> etiquetas;

  EtiquetaFiltroPedidoCompleto({
    required this.pedido,
    required this.etiquetas,
  });

  factory EtiquetaFiltroPedidoCompleto.fromMap(Map<String, dynamic> map) {
    final pedidoRaw = map['pedido'];
    if (pedidoRaw is! Map<String, dynamic>) {
      throw ArgumentError('Resposta inválida: "pedido" não é um objeto.');
    }

    final etiquetasRaw = map['etiquetas'];
    final List<FilterTagOrderModel> tags;
    if (etiquetasRaw is List) {
      tags = etiquetasRaw
          .map((e) => FilterTagOrderModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } else {
      tags = [];
    }

    return EtiquetaFiltroPedidoCompleto(
      pedido: LoadOrder.fromMap(pedidoRaw),
      etiquetas: tags,
    );
  }
}
