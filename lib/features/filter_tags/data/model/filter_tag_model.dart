// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FilterTagModel {
  String nf;
  String serie;
  String embalagem;
  String etiqueta;
  List<FilterTagProductModel> itens;

  FilterTagModel({
    required this.nf,
    required this.serie,
    required this.embalagem,
    required this.etiqueta,
    required this.itens,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nf': nf,
      'serie': serie,
      'embalagem': embalagem,
      'etiqueta': etiqueta,
      'itens': itens.map((x) => x.toMap()).toList(),
    };
  }

  factory FilterTagModel.fromMap(Map<String, dynamic> map) {
    return FilterTagModel(
      nf: map['nf'] ?? '',
      serie: map['serie'] ?? '',
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

  factory FilterTagModel.fromJson(String source) =>
      FilterTagModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class FilterTagProductModel {
  String item;
  String produto;
  String descricao;
  double quatidade;
  String data;
  String hora;

  FilterTagProductModel({
    required this.item,
    required this.produto,
    required this.descricao,
    required this.quatidade,
    required this.data,
    required this.hora,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'item': item,
      'produto': produto,
      'descricao': descricao,
      'quatidade': quatidade,
      'data': data,
      'hora': hora,
    };
  }

  factory FilterTagProductModel.fromMap(Map<String, dynamic> map) {
    return FilterTagProductModel(
      item: map['item'] ?? '',
      produto: map['produto'] ?? '',
      descricao: map['descricao'] ?? '',
      quatidade: map['quantidade']?.toDouble() ?? 0.0,
      data: map['data'] ?? '',
      hora: map['hora'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FilterTagProductModel.fromJson(String source) =>
      FilterTagProductModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
