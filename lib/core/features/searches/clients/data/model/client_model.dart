import 'dart:convert';

class ClientModel {
  String filial;
  String codigo;
  String loja;
  String nome;
  String nomeFantasia;
  ClientModel({
    required this.filial,
    required this.codigo,
    required this.loja,
    required this.nome,
    required this.nomeFantasia,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'filial': filial,
      'codigo': codigo,
      'loja': loja,
      'nome': nome,
      'nomeFantasia': nomeFantasia,
    };
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      filial: map['filial'] as String,
      codigo: map['codigo'] as String,
      loja: map['loja'] as String,
      nome: map['nome'] as String,
      nomeFantasia: map['nomeFantasia'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientModel.fromJson(String source) =>
      ClientModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
