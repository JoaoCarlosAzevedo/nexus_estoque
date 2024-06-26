import 'dart:convert';

class OutFlowDoc {
  String codigoTransp;
  String nomeTransp;
  List<Produtos> produtos;
  String serie;
  String codigoCliente;
  String lojaCliente;
  String nomeCliente;
  String notaFiscal;
  String chaveNFe;

  OutFlowDoc({
    required this.codigoTransp,
    required this.nomeTransp,
    required this.produtos,
    required this.serie,
    required this.codigoCliente,
    required this.lojaCliente,
    required this.nomeCliente,
    required this.notaFiscal,
    required this.chaveNFe,
  });

  Map<String, dynamic> toMap() {
    return {
      'CodigoTransp': codigoTransp,
      'NomeTransp': nomeTransp,
      'produtos': produtos.map((x) => x.toMap()).toList(),
      'Serie': serie,
      'CodigoCliente': codigoCliente,
      'LojaCliente': lojaCliente,
      'NomeCliente': nomeCliente,
      'NotaFiscal': notaFiscal,
      'ChaveNFe': chaveNFe,
    };
  }

  factory OutFlowDoc.fromMap(Map<String, dynamic> map) {
    return OutFlowDoc(
      codigoTransp: map['CodigoTransp'] ?? '',
      nomeTransp: map['NomeTransp'] ?? '',
      produtos:
          List<Produtos>.from(map['produtos']?.map((x) => Produtos.fromMap(x))),
      serie: map['Serie'] ?? '',
      codigoCliente: map['CodigoCliente'] ?? '',
      lojaCliente: map['LojaCliente'] ?? '',
      nomeCliente: map['NomeCliente'] ?? '',
      notaFiscal: map['NotaFiscal'] ?? '',
      chaveNFe: map['ChaveNFe'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OutFlowDoc.fromJson(String source) =>
      OutFlowDoc.fromMap(json.decode(source));
}

class Produtos {
  String descricao;
  double quantidade;
  String barcode;
  String barcode2;
  double checked;
  String item;
  String codigo;
  String um;
  Produtos({
    required this.descricao,
    required this.quantidade,
    required this.barcode,
    required this.barcode2,
    required this.checked,
    required this.item,
    required this.codigo,
    required this.um,
  });

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'quantidade': quantidade,
      'barcode': barcode,
      'barcode2': barcode2,
      'checked': checked,
      'item': item,
      'codigo': codigo,
      'um': um,
    };
  }

  factory Produtos.fromMap(Map<String, dynamic> map) {
    return Produtos(
      descricao: map['descricao'] ?? '',
      quantidade: map['quantidade']?.toDouble() ?? 0,
      barcode: map['barcode'] ?? '',
      barcode2: map['barcode2'] ?? '',
      checked: map['checked']?.toDouble() ?? 0,
      item: map['item'] ?? '',
      codigo: map['codigo'] ?? '',
      um: map['um'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Produtos.fromJson(String source) =>
      Produtos.fromMap(json.decode(source));
}
