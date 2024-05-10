// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class InventoryModel {
  String filial;
  String codPro;
  String descPro;
  String uM;
  String codigoBarras;
  String codigoBarras2;
  String local;
  double quantInvent;
  String tipoPro;
  String data;
  String doc;
  String endereco;
  String codEndereco;
  String chave;
  int recno;
  InventoryModel({
    required this.filial,
    required this.codPro,
    required this.descPro,
    required this.uM,
    required this.codigoBarras,
    required this.codigoBarras2,
    required this.local,
    required this.quantInvent,
    required this.tipoPro,
    required this.data,
    required this.doc,
    required this.endereco,
    required this.codEndereco,
    required this.chave,
    required this.recno,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'filial': filial,
      'codPro': codPro,
      'descPro': descPro,
      'uM': uM,
      'codigoBarras': codigoBarras,
      'codigoBarras2': codigoBarras2,
      'local': local,
      'quantInvent': quantInvent,
      'tipoPro': tipoPro,
      'data': data,
      'doc': doc,
      'endereco': endereco,
      'codEndereco': codEndereco,
      'chave': chave,
      'recno': recno,
    };
  }

  factory InventoryModel.fromMap(Map<String, dynamic> map) {
    return InventoryModel(
      filial: map['Filial'] ?? '',
      codPro: map['CodPro'] ?? '',
      descPro: map['DescPro'] ?? '',
      uM: map['UM'] ?? '',
      codigoBarras: map['CodigoBarras'] ?? '',
      codigoBarras2: map['CodigoBarras2'] ?? '',
      local: map['Local'] ?? '',
      quantInvent: map['QuantInvent']?.toDouble() ?? 0.0,
      tipoPro: map['TipoPro'] ?? '',
      data: map['Data'] ?? '',
      doc: map['Doc'] ?? '',
      endereco: map['Endereco'] ?? '',
      codEndereco: map['CodEndereco'] ?? '',
      chave: map['chave'] ?? '',
      recno: map['recno'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory InventoryModel.fromJson(String source) =>
      InventoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
