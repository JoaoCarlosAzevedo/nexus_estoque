import 'dart:convert';

class AddressBalanceModel {
  final String descProd;
  final String um;
  final String armazem;
  final String codEndereco;
  final double quantidade;
  final double empenho;
  final String endereDesc;
  final String armazemDesc;

  AddressBalanceModel({
    required this.descProd,
    required this.um,
    required this.armazem,
    required this.codEndereco,
    required this.quantidade,
    required this.empenho,
    required this.endereDesc,
    required this.armazemDesc,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'descProd': descProd,
      'UM': um,
      'armazem': armazem,
      'codEndereco': codEndereco,
      'quantidade': quantidade,
      'empenho': empenho,
      'endereDesc': endereDesc,
      'armazemDesc': armazemDesc,
    };
  }

  factory AddressBalanceModel.fromMap(Map<String, dynamic> map) {
    return AddressBalanceModel(
      descProd: map['descProd'] ?? '',
      um: map['UM'] ?? '',
      armazem: map['armazem'] ?? '',
      codEndereco: map['codEndereco'] ?? '',
      quantidade: map['quantidade']?.toDouble() ?? 0.0,
      empenho: map['empenho']?.toDouble() ?? 0.0,
      endereDesc: map['endereDesc'] ?? '',
      armazemDesc: map['armazemDesc'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressBalanceModel.fromJson(String source) =>
      AddressBalanceModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
