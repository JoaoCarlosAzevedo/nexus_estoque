import 'dart:convert';

class ProductModel {
  String descricao;
  String localPadrao;
  String lote;
  String codigoBarras;
  String localizacao;
  String tipo;
  double saldoAtual;
  String um;
  String codigo;

  ProductModel({
    required this.descricao,
    required this.localPadrao,
    required this.lote,
    required this.codigoBarras,
    required this.localizacao,
    required this.tipo,
    required this.saldoAtual,
    required this.um,
    required this.codigo,
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
      um: map['um'] ?? '',
      codigo: map['codigo'] ?? '',
    );
  }

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));
}
