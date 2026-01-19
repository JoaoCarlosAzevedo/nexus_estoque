import 'dart:convert';

class AddressBalanceModel {
  final String descProd;
  final String codProd;
  final String um;
  final String armazem;
  final String codEndereco;
  final double quantidade;
  final double empenho;
  final double separado;
  final String endereDesc;
  final String armazemDesc;
  final String ultimoMov;
  final bool prdInvent;

  AddressBalanceModel({
    required this.descProd,
    required this.codProd,
    required this.um,
    required this.armazem,
    required this.codEndereco,
    required this.quantidade,
    required this.empenho,
    required this.separado,
    required this.endereDesc,
    required this.armazemDesc,
    required this.ultimoMov,
    required this.prdInvent,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'descProd': descProd,
      'codProd': codProd,
      'UM': um,
      'armazem': armazem,
      'codEndereco': codEndereco,
      'quantidade': quantidade,
      'empenho': empenho,
      'endereDesc': endereDesc,
      'separado': separado,
      'armazemDesc': armazemDesc,
      'ultimo_mov': ultimoMov,
      'prdInvent': prdInvent,
    };
  }

  factory AddressBalanceModel.fromMap(Map<String, dynamic> map) {
    return AddressBalanceModel(
      descProd: map['descProd'] ?? '',
      codProd: map['codProd'] ?? '',
      um: map['UM'] ?? '',
      armazem: map['armazem'] ?? '',
      codEndereco: map['codEndereco'] ?? '',
      quantidade: map['quantidade']?.toDouble() ?? 0.0,
      empenho: map['empenho']?.toDouble() ?? 0.0,
      separado: map['separado']?.toDouble() ?? 0.0,
      endereDesc: map['endereDesc'] ?? '',
      armazemDesc: map['armazemDesc'] ?? '',
      ultimoMov: map['ultimo_mov'] ?? '',
      prdInvent: map['prdInvent'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressBalanceModel.fromJson(String source) =>
      AddressBalanceModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
