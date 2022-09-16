import 'dart:convert';

class ProductAddress {
  String codigo;
  String descricao;
  String local;
  String lote;
  double saldo;

  ProductAddress({
    required this.codigo,
    required this.descricao,
    required this.local,
    required this.lote,
    required this.saldo,
  });

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'descricao': descricao,
      'local': local,
      'lote': lote,
      'saldo': saldo,
    };
  }

  factory ProductAddress.fromMap(Map<String, dynamic> map) {
    return ProductAddress(
      codigo: map['codigo'] ?? '',
      descricao: map['descricao'] ?? '',
      local: map['local'] ?? '',
      lote: map['lote'] ?? '',
      saldo: map['saldo']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductAddress.fromJson(String source) =>
      ProductAddress.fromMap(json.decode(source));
}
