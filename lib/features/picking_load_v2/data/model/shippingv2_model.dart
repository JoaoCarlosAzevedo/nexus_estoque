import 'dart:convert';

import 'pickingv2_model.dart';

class Shippingv2Model {
  String codCarga;
  double peso;
  int qtdEntregas;
  String codTransp;
  String descTransp;
  String codRota;
  String descRota;
  List<Pickingv2Model> pedidos;

  Shippingv2Model({
    required this.codCarga,
    required this.peso,
    required this.qtdEntregas,
    required this.codTransp,
    required this.descTransp,
    required this.codRota,
    required this.descRota,
    required this.pedidos,
  });

  Map<String, dynamic> toMap() {
    return {
      'CodCarga': codCarga,
      'Peso': peso,
      'QtdEntregas': qtdEntregas,
      'CodTransp': codTransp,
      'DescTransp': descTransp,
      'codRota': codRota,
      'descRota': descRota,
      'Pedidos': pedidos.map((x) => x.toMap()).toList(),
    };
  }

  factory Shippingv2Model.fromMap(Map<String, dynamic> map) {
    return Shippingv2Model(
      codCarga: map['CodCarga'] ?? '',
      peso: map['Peso']?.toDouble() ?? 0.0,
      qtdEntregas: map['QtdEntregas']?.toInt() ?? 0,
      codTransp: map['CodTransp'] ?? '',
      descTransp: map['DescTransp'] ?? '',
      codRota: map['codigoRota'] ?? '',
      descRota: map['descRota'] ?? '',
      pedidos: List<Pickingv2Model>.from(
        map['Pedidos']?.map((x) => Pickingv2Model.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  bool isFaturado() {
    for (var element in pedidos) {
      if (element.status.trim() == "Faturado") {
        return true;
      }
    }
    return false;
  }

  factory Shippingv2Model.fromJson(String source) =>
      Shippingv2Model.fromMap(json.decode(source));
}
