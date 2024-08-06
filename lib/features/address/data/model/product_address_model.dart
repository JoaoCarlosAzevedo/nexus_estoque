import 'dart:convert';

class ProductAddressModel {
  final String descricao;
  final String numseq;
  final String clifor;
  final String lote;
  final double saldo;
  final String serie;
  final String notafiscal;
  final String data;
  final String um;
  final String armazem;
  final String codigo;
  final String fornecedor;
  final String validade;
  final String chave;
  final String codigoBarras;
  final String codigoBarras2;
  final String enderecoFiltro;

  ProductAddressModel({
    required this.descricao,
    required this.numseq,
    required this.clifor,
    required this.lote,
    required this.saldo,
    required this.serie,
    required this.notafiscal,
    required this.data,
    required this.um,
    required this.armazem,
    required this.codigo,
    required this.fornecedor,
    required this.validade,
    required this.chave,
    required this.codigoBarras,
    required this.enderecoFiltro,
    required this.codigoBarras2,
  });

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'data': data,
      'numseq': numseq,
      'clifor': clifor,
      'lote': lote,
      'saldo': saldo,
      'serie': serie,
      'notafiscal': notafiscal,
      'um': um,
      'armazem': armazem,
      'codigo': codigo,
      'fornecedor': fornecedor,
      'validade': validade,
      'chave': chave,
      'codigobarras': codigoBarras,
      'codigoBarras2': codigoBarras2,
      'enderecoFiltro': enderecoFiltro,
    };
  }

  factory ProductAddressModel.fromMap(Map<String, dynamic> map) {
    return ProductAddressModel(
        descricao: map['descricao'] ?? '',
        data: map['data'] ?? '',
        numseq: map['numseq'] ?? '',
        clifor: map['clifor'] ?? '',
        lote: map['lote'] ?? '',
        saldo: map['saldo']?.toDouble() ?? 0,
        serie: map['serie'] ?? '',
        notafiscal: map['notafiscal'] ?? '',
        um: map['um'] ?? '',
        armazem: map['armazem'] ?? '',
        codigo: map['codigo'] ?? '',
        fornecedor: map['fornecedor'] ?? '',
        validade: map['validade'] ?? '',
        chave: map['chave'] ?? '',
        codigoBarras: map['codigobarras'] ?? '',
        enderecoFiltro: map['endereco_filtro'] ?? '',
        codigoBarras2: map['codigobarras2'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory ProductAddressModel.fromJson(String source) =>
      ProductAddressModel.fromMap(json.decode(source));
}
