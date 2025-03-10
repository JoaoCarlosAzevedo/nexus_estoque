import 'dart:convert';

class ProductMultiplierModel {
  String codigo;
  String descricao;
  double multiplier;

  ProductMultiplierModel({
    required this.codigo,
    required this.descricao,
    required this.multiplier,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'produto': codigo,
      'descricao': descricao,
      'fator': multiplier,
    };
  }

  factory ProductMultiplierModel.fromMap(Map<String, dynamic> map) {
    return ProductMultiplierModel(
      codigo: map['codigo'] ?? '',
      descricao: map['descricao'] ?? '',
      multiplier: map['fator']?.toDouble() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductMultiplierModel.fromJson(String source) =>
      ProductMultiplierModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
