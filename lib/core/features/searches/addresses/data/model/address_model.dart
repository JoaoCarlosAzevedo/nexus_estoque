import 'dart:convert';

class AddressModel {
  String descricao;
  String local;
  String codigoEndereco;

  AddressModel({
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

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      descricao: map['descricao'] ?? '',
      local: map['local'] ?? '',
      codigoEndereco: map['codigoEndereco'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source));
}
