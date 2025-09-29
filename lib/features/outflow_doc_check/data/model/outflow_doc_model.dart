// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  bool isCompleted() {
    for (var product in produtos) {
      if (product.checkedBd < product.quantidade) {
        return false;
      }
    }
    return true;
  }

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
  double checkedBd;
  double fator;
  String item;
  String codigo;
  String um;
  bool manualInput;

  Produtos({
    required this.descricao,
    required this.quantidade,
    required this.barcode,
    required this.barcode2,
    required this.checked,
    required this.checkedBd,
    required this.fator,
    required this.item,
    required this.codigo,
    required this.um,
    required this.manualInput,
  });

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'quantidade': quantidade,
      'barcode': barcode,
      'barcode2': barcode2,
      'checked': checked,
      'checkedBd': checkedBd,
      'fator': fator,
      'item': item,
      'codigo': codigo,
      'um': um,
      'manualInput': manualInput,
    };
  }

  factory Produtos.fromMap(Map<String, dynamic> map) {
    return Produtos(
      descricao: map['descricao'] ?? '',
      quantidade: map['quantidade']?.toDouble() ?? 0,
      barcode: map['barcode'] ?? '',
      barcode2: map['barcode2'] ?? '',
      checked: map['checked']?.toDouble() ?? 0,
      checkedBd: map['checked']?.toDouble() ?? 0,
      fator: map['fator']?.toDouble() ?? 0,
      item: map['item'] ?? '',
      codigo: map['codigo'] ?? '',
      um: map['um'] ?? '',
      manualInput: map['manualInput'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Produtos.fromJson(String source) =>
      Produtos.fromMap(json.decode(source));
}

class GroupedProducts {
  String produto;
  String descricao;
  String barcode1;
  String barcode2;
  List<Produtos> products;
  GroupedProducts({
    required this.produto,
    required this.descricao,
    required this.barcode1,
    required this.barcode2,
    required this.products,
  });

  double getTotalConferido() {
    return products.fold(0.0, (a, b) => a + b.checked);
  }

  double getTotalNF() {
    return products.fold(0.0, (a, b) => a + b.quantidade);
  }
}
