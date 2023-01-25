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
      'Descricao': descricao,
      'Filial': filial,
      'Codigo': codigo,
    };
  }

  factory WarehouseModel.fromMap(Map<String, dynamic> map) {
    return WarehouseModel(
      descricao: map['Descricao'] ?? '',
      filial: map['Filial'] ?? '',
      codigo: map['Codigo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WarehouseModel.fromJson(String source) =>
      WarehouseModel.fromMap(json.decode(source));
}
