// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductModel {
  String descricao;
  String localPadrao;
  String lote;
  String codigoBarras;
  String localizacao;
  String tipo;
  double saldoAtual;
  double qtdInvet;
  String um;
  String codigo;
  String error;

  ProductModel({
    required this.descricao,
    required this.localPadrao,
    required this.lote,
    required this.codigoBarras,
    required this.localizacao,
    required this.tipo,
    required this.saldoAtual,
    required this.qtdInvet,
    required this.um,
    required this.codigo,
    required this.error,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      descricao: map['descricao'] ?? '',
      localPadrao: map['localpadrao'] ?? '',
      codigoBarras: map['codigobarras'] ?? '',
      lote: map['lotes'] ?? '',
      localizacao: map['localizacao'] ?? '',
      tipo: map['tipo'] ?? '',
      saldoAtual: map['saldo']?.toDouble() ?? 0.0,
      qtdInvet: map['qtdInvet']?.toDouble() ?? 0.0,
      um: map['um'] ?? '',
      codigo: map['codigo'] ?? '',
      error: map['error'] ?? '',
    );
  }

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));

  ProductModel copyWith({
    String? descricao,
    String? localPadrao,
    String? lote,
    String? codigoBarras,
    String? localizacao,
    String? tipo,
    double? saldoAtual,
    double? qtdInvet,
    String? um,
    String? codigo,
    String? error,
  }) {
    return ProductModel(
      descricao: descricao ?? this.descricao,
      localPadrao: localPadrao ?? this.localPadrao,
      lote: lote ?? this.lote,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      localizacao: localizacao ?? this.localizacao,
      tipo: tipo ?? this.tipo,
      saldoAtual: saldoAtual ?? this.saldoAtual,
      qtdInvet: qtdInvet ?? this.qtdInvet,
      um: um ?? this.um,
      codigo: codigo ?? this.codigo,
      error: error ?? this.error,
    );
  }
}
