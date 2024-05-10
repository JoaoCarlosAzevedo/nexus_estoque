// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:nexus_estoque/core/features/searches/addresses/data/model/address_model.dart';
import 'package:nexus_estoque/core/features/searches/batches/data/model/batch_model.dart';

class ProductBalanceModel {
  String descricao;
  String localPadrao;
  String codigoBarras;
  String codigoBarras2;
  String lote;
  String localizacao;
  String tipo;
  String uM;
  List<BalanceWarehouse> armazem;
  String codigo;

  double get stock {
    return armazem.fold(0, (sum, element) => sum + element.saldoLocal);
  }

  ProductBalanceModel({
    required this.descricao,
    required this.localPadrao,
    required this.codigoBarras,
    required this.lote,
    required this.localizacao,
    required this.tipo,
    required this.uM,
    required this.armazem,
    required this.codigo,
    required this.codigoBarras2,
  });

  factory ProductBalanceModel.fromMap(Map<String, dynamic> map) {
    return ProductBalanceModel(
      descricao: map['descricao'] ?? '',
      localPadrao: map['localpadrao'] ?? '',
      codigoBarras: map['codigobarras'] ?? '',
      lote: map['lote'] ?? '',
      localizacao: map['localizacao'] ?? '',
      tipo: map['tipo'] ?? '',
      uM: map['um'] ?? '',
      armazem: List<BalanceWarehouse>.from(
          map['armazem']?.map((x) => BalanceWarehouse.fromMap(x))),
      codigo: map['codigo'] ?? '',
      codigoBarras2: map['codigobarras2'] ?? '',
    );
  }

  factory ProductBalanceModel.fromJson(String source) =>
      ProductBalanceModel.fromMap(json.decode(source));
}

class BalanceWarehouse {
  List<AddressModel> enderecos;
  List<BatchModel> lotes;
  String codigo;
  String descricao;
  String filial;
  double saldoLocal;

  BalanceWarehouse({
    required this.enderecos,
    required this.lotes,
    required this.codigo,
    required this.descricao,
    required this.filial,
    required this.saldoLocal,
  });

  factory BalanceWarehouse.fromMap(Map<String, dynamic> map) {
    return BalanceWarehouse(
      enderecos: List<AddressModel>.from(
          map['enderecos']?.map((x) => AddressModel.fromMap(x))),
      lotes: List<BatchModel>.from(
          map['lotes']?.map((x) => BatchModel.fromMap(x))),
      codigo: map['codigo'] ?? '',
      descricao: map['descricao'] ?? '',
      saldoLocal: map['saldo']?.toDouble() ?? 0,
      filial: map['filial'] ?? '',
    );
  }

  factory BalanceWarehouse.fromJson(String source) =>
      BalanceWarehouse.fromMap(json.decode(source));
}
