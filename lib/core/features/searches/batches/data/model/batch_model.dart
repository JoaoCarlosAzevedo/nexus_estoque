import 'dart:convert';

class BatchModel {
  String emissao;
  String lote;
  String validade;
  double qtdori;
  double saldo;
  String lotefor;
  String filial;
  String armazem;
  String codigo;

  BatchModel({
    required this.emissao,
    required this.lote,
    required this.validade,
    required this.qtdori,
    required this.saldo,
    required this.lotefor,
    required this.filial,
    required this.armazem,
    required this.codigo,
  });

  Map<String, dynamic> toMap() {
    return {
      'emissao': emissao,
      'lote': lote,
      'validade': validade,
      'qtdori': qtdori,
      'saldo': saldo,
      'lotefor': lotefor,
      'filial': filial,
      'armazem': armazem,
      'codigo': codigo,
    };
  }

  factory BatchModel.fromMap(Map<String, dynamic> map) {
    return BatchModel(
      emissao: map['emissao'] ?? '',
      lote: map['lote'] ?? '',
      validade: map['validade'] ?? '',
      qtdori: map['qtdori']?.toDouble() ?? 0.0,
      saldo: map['saldo']?.toDouble() ?? 0.0,
      lotefor: map['lotefor'] ?? '',
      filial: map['filial'] ?? '',
      armazem: map['armazem'] ?? '',
      codigo: map['codigo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BatchModel.fromJson(String source) =>
      BatchModel.fromMap(json.decode(source));
}
