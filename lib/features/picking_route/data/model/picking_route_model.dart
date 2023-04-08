import 'dart:convert';

import 'package:nexus_estoque/features/picking_route/data/model/shipping_model.dart';

class PickingRouteModel {
  String codRota;
  String descRota;
  List<ShippingModel> cargas;
  PickingRouteModel({
    required this.codRota,
    required this.descRota,
    required this.cargas,
  });

  Map<String, dynamic> toMap() {
    return {
      'CodRota': codRota,
      'DescRota': descRota,
      'Cargas': cargas.map((x) => x.toMap()).toList(),
    };
  }

  factory PickingRouteModel.fromMap(Map<String, dynamic> map) {
    return PickingRouteModel(
      codRota: map['CodRota'] ?? '',
      descRota: map['DescRota'] ?? '',
      cargas: List<ShippingModel>.from(
          map['Cargas']?.map((x) => ShippingModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory PickingRouteModel.fromJson(String source) =>
      PickingRouteModel.fromMap(json.decode(source));
}
