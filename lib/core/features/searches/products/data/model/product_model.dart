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

  Map<String, dynamic> toMap() {
    return {
      'Descricao': descricao,
      'LocalPadrao': localPadrao,
      'Lote': lote,
      'CodigoBarras': codigoBarras,
      'Localizacao': localizacao,
      'Tipo': tipo,
      'SaldoAtual': saldoAtual,
      'UM': um,
      'Codigo': codigo,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      descricao: map['Descricao'] ?? '',
      localPadrao: map['LocalPadrao'] ?? '',
      codigoBarras: map['CodigoBarras'] ?? '',
      lote: map['Lote'] ?? '',
      localizacao: map['Localizacao'] ?? '',
      tipo: map['Tipo'] ?? '',
      saldoAtual: map['SaldoAtual']?.toDouble() ?? 0.0,
      um: map['UM'] ?? '',
      codigo: map['Codigo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));
}
