// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../../filter_tags/data/model/filter_tag_model.dart';

class FilterTagOrderModel {
  String pedido;
  String embalagem;
  String etiqueta;
  List<FilterTagProductModel> itens;

  FilterTagOrderModel({
    required this.pedido,
    required this.embalagem,
    required this.etiqueta,
    required this.itens,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pedido': pedido,
      'embalagem': embalagem,
      'etiqueta': etiqueta,
      'itens': itens.map((x) => x.toMap()).toList(),
    };
  }

  factory FilterTagOrderModel.fromMap(Map<String, dynamic> map) {
    return FilterTagOrderModel(
      pedido: map['pedido'] ?? '',
      embalagem: map['embalagem'] ?? '',
      etiqueta: map['etiqueta'] ?? '',
      itens: List<FilterTagProductModel>.from(
        map['itens']?.map(
          (x) => FilterTagProductModel.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory FilterTagOrderModel.fromJson(String source) =>
      FilterTagOrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
