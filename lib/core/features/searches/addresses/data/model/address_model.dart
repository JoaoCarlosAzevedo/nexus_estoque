// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AddressModel {
  String descricao;
  String local;
  String codigo;
  String lote;
  String armzDesc;
  double quantidade;
  double empenho;
  String ultimoMov;

  AddressModel(
      {required this.descricao,
      required this.local,
      required this.codigo,
      required this.lote,
      required this.quantidade,
      required this.empenho,
      required this.ultimoMov,
      required this.armzDesc});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'descricao': descricao,
      'armazem': local,
      'codigo': codigo,
      'lote': lote,
      'quantidade': quantidade,
      'armazemDesc': armzDesc,
      'ultimo_mov': ultimoMov
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      descricao: map['descricao'] ?? '',
      local: map['armazem'] ?? '',
      codigo: map['codigo'] ?? '',
      lote: map['lote'] ?? '',
      armzDesc: map['armazemDesc'] ?? '',
      quantidade: map['quantidade']?.toDouble() ?? 0,
      empenho: map['empenho']?.toDouble() ?? 0,
      ultimoMov: map['ultimo_mov'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
