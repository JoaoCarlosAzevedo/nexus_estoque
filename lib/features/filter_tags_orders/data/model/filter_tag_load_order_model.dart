// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class LoadOrder {
  String filialcarga;
  String carga;
  double peso;
  String data;
  int entregas;
  List<Orders> pedidos;

  LoadOrder(
      {required this.filialcarga,
      required this.carga,
      required this.peso,
      required this.data,
      required this.entregas,
      required this.pedidos});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'filialcarga': filialcarga,
      'carga': carga,
      'peso': peso,
      'data': data,
      'entregas': entregas,
      'pedidos': pedidos.map((x) => x.toMap()).toList(),
    };
  }

  factory LoadOrder.fromMap(Map<String, dynamic> map) {
    return LoadOrder(
      filialcarga: map['filial_carga'] ?? '',
      carga: map['carga'] ?? '',
      peso: map['peso'].toDouble() ?? 0.0,
      data: map['data'] ?? '',
      entregas: map['entregas']?.toInt() ?? 0,
      pedidos: List<Orders>.from(
        map['pedidos']?.map(
          (x) => Orders.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory LoadOrder.fromJson(String source) =>
      LoadOrder.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Orders {
  String filialPed;
  String pedido;

  String codigoCliente;
  String lojaCliente;
  String nomeCliente;
  String codigoTransp;
  String nomeTransp;

  List<OrdersProduct> itens;

  Orders(
      {required this.filialPed,
      required this.pedido,
      required this.codigoCliente,
      required this.lojaCliente,
      required this.nomeCliente,
      required this.codigoTransp,
      required this.nomeTransp,
      required this.itens});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'filialPed': filialPed,
      'pedido': pedido,
      'codigoCliente': codigoCliente,
      'lojaCliente': lojaCliente,
      'nomeCliente': nomeCliente,
      'codigoTransp': codigoTransp,
      'nomeTransp': nomeTransp,
      'itens': itens.map((x) => x.toMap()).toList(),
    };
  }

  factory Orders.fromMap(Map<String, dynamic> map) {
    return Orders(
      filialPed: map['filial_nf'] ?? '',
      pedido: map['pedido'] ?? '',
      codigoCliente: map['CodigoCliente'] ?? '',
      lojaCliente: map['LojaCliente'] ?? '',
      nomeCliente: map['NomeCliente'] ?? '',
      codigoTransp: map['CodigoTransp'] ?? '',
      nomeTransp: map['NomeTransp'] ?? '',
      itens: List<OrdersProduct>.from(
        map['itens']?.map(
          (x) => OrdersProduct.fromMap(x),
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
    final double quantityOrders =
        itens.fold(0, (sum, element) => sum + element.quantidade);

    if (quantityTags >= quantityOrders) {
      return Colors.green;
    }

    if (quantityTags < quantityOrders && quantityTags > 0) {
      return Colors.blue;
    }
    return Colors.grey.shade300;
  }

  factory Orders.fromJson(String source) =>
      Orders.fromMap(json.decode(source) as Map<String, dynamic>);
}

class OrdersProduct {
  String codigo;
  String descricao;
  String um;
  String item;
  double quantidade;
  String codigobarras;
  String codigobarras2;
  double quantidaetiqueta;
  double novaQuantidade;
  String carga;

  OrdersProduct(
      {required this.codigo,
      required this.descricao,
      required this.um,
      required this.item,
      required this.quantidade,
      required this.codigobarras,
      required this.codigobarras2,
      required this.novaQuantidade,
      required this.quantidaetiqueta,
      required this.carga});

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
      'carga': carga,
    };
  }

  factory OrdersProduct.fromMap(Map<String, dynamic> map) {
    return OrdersProduct(
      codigo: map['codigo'] ?? '',
      descricao: map['descricao'] ?? '',
      um: map['um'] ?? '',
      item: map['item'] ?? '',
      quantidade: map['quantidade'].toDouble() ?? 0.0,
      codigobarras: map['codigobarras'] ?? '',
      codigobarras2: map['codigobarras2'] ?? '',
      quantidaetiqueta: map['quantida_etiqueta'].toDouble() ?? 0.0,
      novaQuantidade: 0.0,
      carga: map['carga'] ?? '',
    );
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

  factory OrdersProduct.fromJson(String source) =>
      OrdersProduct.fromMap(json.decode(source) as Map<String, dynamic>);
}
