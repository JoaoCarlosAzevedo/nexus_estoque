class EtiquetaPedidoV3Item {
  final String pedido;
  final String carga;
  final String codigoRota;
  final String descRota;

  EtiquetaPedidoV3Item({
    required this.pedido,
    required this.carga,
    required this.codigoRota,
    required this.descRota,
  });

  factory EtiquetaPedidoV3Item.fromMap(Map<String, dynamic> map) {
    return EtiquetaPedidoV3Item(
      pedido: (map['pedido'] ?? '').toString().trim(),
      carga: (map['carga'] ?? '').toString().trim(),
      codigoRota: (map['codigoRota'] ?? '').toString().trim(),
      descRota: (map['descRota'] ?? '').toString().trim(),
    );
  }
}
