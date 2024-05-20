// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PurchaseInvoice {
  String filial;
  String notaFiscal;
  String serie;
  String codigoFornece;
  String lojaFornece;
  String nomeCliente;
  String codigoTransp;
  String nomeTransp;
  String chaveNFe;
  String codVeiculo;
  String descVeiculo;
  String placaVeiculo;

  List<PurchaseInvoiceProduct> purchaseInvoiceProducts;

  PurchaseInvoice({
    required this.filial,
    required this.notaFiscal,
    required this.serie,
    required this.codigoFornece,
    required this.lojaFornece,
    required this.nomeCliente,
    required this.codigoTransp,
    required this.nomeTransp,
    required this.chaveNFe,
    required this.codVeiculo,
    required this.descVeiculo,
    required this.placaVeiculo,
    required this.purchaseInvoiceProducts,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'filial': filial,
      'notaFiscal': notaFiscal,
      'serie': serie,
      'codigoFornece': codigoFornece,
      'lojaFornece': lojaFornece,
      'nomeCliente': nomeCliente,
      'codigoTransp': codigoTransp,
      'nomeTransp': nomeTransp,
      'chaveNFe': chaveNFe,
      'codVeiculo': codVeiculo,
      'descVeiculo': descVeiculo,
      'placaVeiculo': placaVeiculo,
      'produtos': purchaseInvoiceProducts.map((x) => x.toMap()).toList(),
    };
  }

  factory PurchaseInvoice.fromMap(Map<String, dynamic> map) {
    return PurchaseInvoice(
      filial: map['filial'] ?? '',
      notaFiscal: map['NotaFiscal'] ?? '',
      serie: map['Serie'] ?? '',
      codigoFornece: map['CodigoFornece'] ?? '',
      lojaFornece: map['LojaFornece'] ?? '',
      nomeCliente: map['NomeCliente'] ?? '',
      codigoTransp: map['CodigoTransp'] ?? '',
      nomeTransp: map['NomeTransp'] ?? '',
      chaveNFe: map['ChaveNFe'] ?? '',
      codVeiculo: map['codVeiculo'] ?? '',
      descVeiculo: map['descVeiculo'] ?? '',
      placaVeiculo: map['placaVeiculo'] ?? '',
      purchaseInvoiceProducts: List<PurchaseInvoiceProduct>.from(
        (map['produtos'] as List<dynamic>).map<PurchaseInvoiceProduct>(
          (x) => PurchaseInvoiceProduct.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory PurchaseInvoice.fromJson(String source) =>
      PurchaseInvoice.fromMap(json.decode(source) as Map<String, dynamic>);
}

class PurchaseInvoiceProduct {
  String codigo;
  String descricao;
  String item;
  double quantidade;
  String barcode;
  String barcode2;
  String um;
  double checked;
  String sd1Chave;

  PurchaseInvoiceProduct({
    required this.codigo,
    required this.descricao,
    required this.item,
    required this.quantidade,
    required this.barcode,
    required this.barcode2,
    required this.um,
    required this.checked,
    required this.sd1Chave,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codigo': codigo,
      'descricao': descricao,
      'item': item,
      'quantidade': quantidade,
      'barcode': barcode,
      'barcode2': barcode2,
      'um': um,
      'checked': checked,
      'SD1Chave': sd1Chave,
    };
  }

  factory PurchaseInvoiceProduct.fromMap(Map<String, dynamic> map) {
    return PurchaseInvoiceProduct(
      codigo: map['codigo'] ?? '',
      descricao: map['descricao'] ?? '',
      item: map['item'] ?? '',
      quantidade: map['quantidade']?.toDouble() ?? 0,
      barcode: map['barcode'] ?? '',
      barcode2: map['barcode2'] ?? '',
      um: map['um'] ?? '',
      checked: map['checked']?.toDouble() ?? 0,
      sd1Chave: map['SD1Chave'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PurchaseInvoiceProduct.fromJson(String source) =>
      PurchaseInvoiceProduct.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
