import 'dart:convert';

class QueryAddressModel {
  final String code;
  final String description;
  QueryAddressModel({
    required this.code,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'codigo': code,
      'descricao': description,
    };
  }

  factory QueryAddressModel.fromMap(Map<String, dynamic> map) {
    return QueryAddressModel(
      code: map['codigo'] ?? '',
      description: map['descricao'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory QueryAddressModel.fromJson(String source) =>
      QueryAddressModel.fromMap(json.decode(source));
}
