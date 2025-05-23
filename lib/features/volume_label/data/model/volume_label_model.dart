// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VolumeLabelModel {
  String numExp;
  String pedido;
  String volume;
  String zpl;

  VolumeLabelModel({
    required this.numExp,
    required this.pedido,
    required this.volume,
    required this.zpl,
  });

  Map<String, dynamic> toMap() {
    return {
      'numExp': numExp,
      'pedido': pedido,
      'volume': volume,
      'zpl': zpl,
    };
  }

  factory VolumeLabelModel.fromMap(Map<String, dynamic> map) {
    return VolumeLabelModel(
      numExp: map['numExp'] ?? '',
      pedido: map['pedido'] ?? '',
      volume: map['volume'] ?? '',
      zpl: map['zpl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VolumeLabelModel.fromJson(String source) =>
      VolumeLabelModel.fromMap(json.decode(source));
}
