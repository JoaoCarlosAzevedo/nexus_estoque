import 'dart:convert';

import 'package:nexus_estoque/features/picking/data/model/picking_model.dart';

class PickingOrder {
  String pedido;
  String codCliente;
  String descCliente;
  double quantidade;
  double separado;
  List<PickingModel> itens;

  PickingOrder({
    required this.pedido,
    required this.codCliente,
    required this.descCliente,
    required this.quantidade,
    required this.separado,
    required this.itens,
  });

  Map<String, dynamic> toMap() {
    return {
      'pedido': pedido,
      'codCliente': codCliente,
      'descCliente': descCliente,
      'quantidade': quantidade,
      'separado': separado,
      'itens': itens.map((x) => x.toMap()).toList(),
    };
  }

  factory PickingOrder.fromMap(Map<String, dynamic> map) {
    return PickingOrder(
      pedido: map['pedido'] ?? '',
      codCliente: map['codCliente'] ?? '',
      descCliente: map['descCliente'] ?? '',
      quantidade: map['quantidade']?.toDouble() ?? 0.0,
      separado: map['separado']?.toDouble() ?? 0.0,
      itens: List<PickingModel>.from(
          map['itens']?.map((x) => PickingModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory PickingOrder.fromJson(String source) =>
      PickingOrder.fromMap(json.decode(source));
}
