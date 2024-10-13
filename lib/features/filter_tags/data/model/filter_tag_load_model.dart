// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class Load {
  String filialcarga;
  String carga;
  double peso;
  String data;
  int entregas;
  List<Invoice> nfs;

  Load(
      {required this.filialcarga,
      required this.carga,
      required this.peso,
      required this.data,
      required this.entregas,
      required this.nfs});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'filialcarga': filialcarga,
      'carga': carga,
      'peso': peso,
      'data': data,
      'entregas': entregas,
      'nfs': nfs.map((x) => x.toMap()).toList(),
    };
  }

  factory Load.fromMap(Map<String, dynamic> map) {
    return Load(
      filialcarga: map['filial_carga'] ?? '',
      carga: map['carga'] ?? '',
      peso: map['peso'].toDouble() ?? 0.0,
      data: map['data'] ?? '',
      entregas: map['entregas']?.toInt() ?? 0,
      nfs: List<Invoice>.from(
        map['nfs']?.map(
          (x) => Invoice.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Load.fromJson(String source) =>
      Load.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Invoice {
  String filialnf;
  String notaFiscal;
  String serie;
  String codigoCliente;
  String lojaCliente;
  String nomeCliente;
  String codigoTransp;
  String nomeTransp;
  String chaveNFe;
  List<InvoiceProduct> itens;

  Invoice(
      {required this.filialnf,
      required this.notaFiscal,
      required this.serie,
      required this.codigoCliente,
      required this.lojaCliente,
      required this.nomeCliente,
      required this.codigoTransp,
      required this.nomeTransp,
      required this.chaveNFe,
      required this.itens});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'filialnf': filialnf,
      'NotaFiscal': notaFiscal,
      'Serie': serie,
      'codigoCliente': codigoCliente,
      'lojaCliente': lojaCliente,
      'nomeCliente': nomeCliente,
      'codigoTransp': codigoTransp,
      'nomeTransp': nomeTransp,
      'chaveNFe': chaveNFe,
      'itens': itens.map((x) => x.toMap()).toList(),
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      filialnf: map['filial_nf'] ?? '',
      notaFiscal: map['NotaFiscal'] ?? '',
      serie: map['Serie'] ?? '',
      codigoCliente: map['CodigoCliente'] ?? '',
      lojaCliente: map['LojaCliente'] ?? '',
      nomeCliente: map['NomeCliente'] ?? '',
      codigoTransp: map['CodigoTransp'] ?? '',
      nomeTransp: map['NomeTransp'] ?? '',
      chaveNFe: map['ChaveNFe'] ?? '',
      itens: List<InvoiceProduct>.from(
        map['itens']?.map(
          (x) => InvoiceProduct.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  bool hasTag() {
    final index = itens.indexWhere((element) => element.quantidaetiqueta > 0);
    if (index >= 0) {
      return true;
    } else {
      return false;
    }
  }

  Color? statusTags() {
    final double quantityTags =
        itens.fold(0, (sum, element) => sum + element.quantidaetiqueta);
    final double quantityInvoice =
        itens.fold(0, (sum, element) => sum + element.quantidade);

    if (quantityTags >= quantityInvoice) {
      return Colors.green;
    }

    if (quantityTags < quantityInvoice && quantityTags > 0) {
      return Colors.blue;
    }
    return Colors.grey.shade300;
  }

  factory Invoice.fromJson(String source) =>
      Invoice.fromMap(json.decode(source) as Map<String, dynamic>);
}

class InvoiceProduct {
  String codigo;
  String descricao;
  String um;
  String item;
  double quantidade;
  String codigobarras;
  String codigobarras2;
  double quantidaetiqueta;
  double novaQuantidade;

  InvoiceProduct(
      {required this.codigo,
      required this.descricao,
      required this.um,
      required this.item,
      required this.quantidade,
      required this.codigobarras,
      required this.codigobarras2,
      required this.novaQuantidade,
      required this.quantidaetiqueta});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codigo': codigo,
      'descricao': descricao,
      'um': um,
      'item': item,
      'quantidade': quantidade,
      'codigobarras': codigobarras,
      'codigobarras2': codigobarras2,
      'quantidaetiqueta': quantidaetiqueta,
      'nova_quantidade': novaQuantidade,
    };
  }

  factory InvoiceProduct.fromMap(Map<String, dynamic> map) {
    return InvoiceProduct(
      codigo: map['codigo'] ?? '',
      descricao: map['descricao'] ?? '',
      um: map['um'] ?? '',
      item: map['item'] ?? '',
      quantidade: map['quantidade'].toDouble() ?? 0.0,
      codigobarras: map['codigobarras'] ?? '',
      codigobarras2: map['codigobarras2'] ?? '',
      quantidaetiqueta: map['quantida_etiqueta'].toDouble() ?? 0.0,
      novaQuantidade: 0.0,
    );
  }

  Color status() {
    if (quantidaetiqueta + novaQuantidade >= quantidade) {
      return Colors.green;
    }

    if (quantidaetiqueta + novaQuantidade < quantidade &&
        quantidaetiqueta + novaQuantidade > 0) {
      return Colors.blue;
    }

    return Colors.grey.shade300;
  }

  String toJson() => json.encode(toMap());

  Color statusTags() {
    if (quantidaetiqueta + novaQuantidade >= quantidade) {
      return Colors.green;
    }

    if (quantidaetiqueta + novaQuantidade < quantidade &&
        quantidaetiqueta + novaQuantidade > 0) {
      return Colors.blue;
    }

    return Colors.grey.shade300;
  }

  factory InvoiceProduct.fromJson(String source) =>
      InvoiceProduct.fromMap(json.decode(source) as Map<String, dynamic>);
}
