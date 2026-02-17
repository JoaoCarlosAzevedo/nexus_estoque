class OrderCheckModel {
  final String pedido;
  final String cliente;
  final String estado;
  final String municipio;
  final List<OrderCheckItemModel> itens;

  OrderCheckModel({
    required this.pedido,
    required this.cliente,
    required this.estado,
    required this.municipio,
    required this.itens,
  });

  factory OrderCheckModel.fromJson(Map<String, dynamic> json) {
    return OrderCheckModel(
      pedido: json['pedido']?.toString() ?? '',
      cliente: json['cliente']?.toString() ?? '',
      estado: json['estado']?.toString() ?? '',
      municipio: json['municipio']?.toString() ?? '',
      itens: (json['itens'] as List<dynamic>?)
              ?.map((item) => OrderCheckItemModel.fromJson(
                    item as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pedido': pedido,
      'cliente': cliente,
      'estado': estado,
      'municipio': municipio,
      'itens': itens.map((item) => item.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderCheckModel &&
          runtimeType == other.runtimeType &&
          pedido == other.pedido;

  @override
  int get hashCode => pedido.hashCode;
}

class OrderCheckItemModel {
  final String item;
  final String codProduto;
  final String descProduto;
  final int quantidade;
  final int conferido;
  final int separado;
  final int recno;

  OrderCheckItemModel({
    required this.item,
    required this.codProduto,
    required this.descProduto,
    required this.quantidade,
    required this.conferido,
    required this.separado,
    required this.recno,
  });

  factory OrderCheckItemModel.fromJson(Map<String, dynamic> json) {
    return OrderCheckItemModel(
      item: json['item']?.toString() ?? '',
      codProduto: json['codProduto']?.toString() ?? '',
      descProduto: json['descProduto']?.toString() ?? '',
      quantidade: json['quantidade'] is int
          ? json['quantidade'] as int
          : int.tryParse(json['quantidade']?.toString() ?? '0') ?? 0,
      conferido: json['conferido'] is int
          ? json['conferido'] as int
          : int.tryParse(json['conferido']?.toString() ?? '0') ?? 0,
      separado: json['separado'] is int
          ? json['separado'] as int
          : int.tryParse(json['separado']?.toString() ?? '0') ?? 0,
      recno: json['recno'] is int
          ? json['recno'] as int
          : int.tryParse(json['recno']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': item,
      'codProduto': codProduto,
      'descProduto': descProduto,
      'quantidade': quantidade,
      'conferido': conferido,
      'separado': separado,
      'recno': recno,
    };
  }

  OrderCheckItemModel copyWith({
    String? item,
    String? codProduto,
    String? descProduto,
    int? quantidade,
    int? conferido,
    int? separado,
    int? recno,
  }) {
    return OrderCheckItemModel(
      item: item ?? this.item,
      codProduto: codProduto ?? this.codProduto,
      descProduto: descProduto ?? this.descProduto,
      quantidade: quantidade ?? this.quantidade,
      conferido: conferido ?? this.conferido,
      separado: separado ?? this.separado,
      recno: recno ?? this.recno,
    );
  }
}
