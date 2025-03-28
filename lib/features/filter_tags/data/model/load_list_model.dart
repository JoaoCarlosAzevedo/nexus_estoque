import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoadModel {
  String load;
  String codTransp;
  String nomeTransp;
  String codRota;
  String descRota;

  LoadModel({
    required this.load,
    required this.codTransp,
    required this.nomeTransp,
    required this.codRota,
    required this.descRota,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'load': load,
      'codTransp': codTransp,
      'nomeTransp': nomeTransp,
      'codRota': codRota,
      'descRota': descRota,
    };
  }

  factory LoadModel.fromMap(Map<String, dynamic> map) {
    return LoadModel(
      load: map['codcarga'] ?? "",
      codTransp: map['codtransp'] ?? "",
      nomeTransp: map['desctransp'] ?? "",
      codRota: map['codrota'] ?? "",
      descRota: map['descrota'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory LoadModel.fromJson(String source) =>
      LoadModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
