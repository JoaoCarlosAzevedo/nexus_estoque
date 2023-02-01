import 'dart:convert';

class WarehouseModel {
  String descricao;
  String filial;
  String codigo;

  WarehouseModel({
    required this.descricao,
    required this.filial,
    required this.codigo,
  });

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'filial': filial,
      'codigo': codigo,
    };
  }

  factory WarehouseModel.fromMap(Map<String, dynamic> map) {
    return WarehouseModel(
      descricao: map['descricao'] ?? '',
      filial: map['filial'] ?? '',
      codigo: map['codigo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WarehouseModel.fromJson(String source) =>
      WarehouseModel.fromMap(json.decode(source));
}
