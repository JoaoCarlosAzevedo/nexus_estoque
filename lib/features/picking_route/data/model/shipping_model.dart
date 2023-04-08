import 'dart:convert';

import 'package:nexus_estoque/features/picking/data/model/picking_order_model.dart';

class ShippingModel {
  String codCarga;
  double peso;
  int qtdEntregas;
  String codTransp;
  String descTransp;
  List<PickingOrder> pedidos;
  ShippingModel({
    required this.codCarga,
    required this.peso,
    required this.qtdEntregas,
    required this.codTransp,
    required this.descTransp,
    required this.pedidos,
  });

  Map<String, dynamic> toMap() {
    return {
      'CodCarga': codCarga,
      'Peso': peso,
      'QtdEntregas': qtdEntregas,
      'CodTransp': codTransp,
      'DescTransp': descTransp,
      'Pedidos': pedidos.map((x) => x.toMap()).toList(),
    };
  }

  factory ShippingModel.fromMap(Map<String, dynamic> map) {
    return ShippingModel(
      codCarga: map['CodCarga'] ?? '',
      peso: map['Peso']?.toDouble() ?? 0.0,
      qtdEntregas: map['QtdEntregas']?.toInt() ?? 0,
      codTransp: map['CodTransp'] ?? '',
      descTransp: map['DescTransp'] ?? '',
      pedidos: List<PickingOrder>.from(
          map['Pedidos']?.map((x) => PickingOrder.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ShippingModel.fromJson(String source) =>
      ShippingModel.fromMap(json.decode(source));
}
