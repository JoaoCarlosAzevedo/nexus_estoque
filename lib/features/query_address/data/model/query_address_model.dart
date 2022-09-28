import 'dart:convert';

class QueryAddressModel {
  final String descricao;
  final String local;
  final String codigoEndereco;

  QueryAddressModel({
    required this.descricao,
    required this.local,
    required this.codigoEndereco,
  });

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'local': local,
      'codigoEndereco': codigoEndereco,
    };
  }

  factory QueryAddressModel.fromMap(Map<String, dynamic> map) {
    return QueryAddressModel(
      descricao: map['descricao'] ?? '',
      local: map['local'] ?? '',
      codigoEndereco: map['codigoEndereco'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory QueryAddressModel.fromJson(String source) =>
      QueryAddressModel.fromMap(json.decode(source));
}
