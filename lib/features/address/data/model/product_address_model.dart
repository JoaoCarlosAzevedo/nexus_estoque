import 'dart:convert';

class ProductAddressModel {
  final String descricao;
  final String numseq;
  final String clifor;
  final String lote;
  final int saldo;
  final String serie;
  final String notafiscal;
  final String um;
  final String armazem;
  final String codigo;

  ProductAddressModel({
    required this.descricao,
    required this.numseq,
    required this.clifor,
    required this.lote,
    required this.saldo,
    required this.serie,
    required this.notafiscal,
    required this.um,
    required this.armazem,
    required this.codigo,
  });

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'numseq': numseq,
      'clifor': clifor,
      'lote': lote,
      'saldo': saldo,
      'serie': serie,
      'notafiscal': notafiscal,
      'um': um,
      'armazem': armazem,
      'codigo': codigo,
    };
  }

  factory ProductAddressModel.fromMap(Map<String, dynamic> map) {
    return ProductAddressModel(
      descricao: map['descricao'] ?? '',
      numseq: map['numseq'] ?? '',
      clifor: map['clifor'] ?? '',
      lote: map['lote'] ?? '',
      saldo: map['saldo']?.toInt() ?? 0,
      serie: map['serie'] ?? '',
      notafiscal: map['notafiscal'] ?? '',
      um: map['um'] ?? '',
      armazem: map['armazem'] ?? '',
      codigo: map['codigo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductAddressModel.fromJson(String source) =>
      ProductAddressModel.fromMap(json.decode(source));
}
