import 'dart:convert';

class AddressTagModel {
  int recno;
  String departamento;
  String apartamento;
  String rua;
  String predio;
  String nivel;
  String filial;
  String codEndereco;
  String descricao;
  String armazem;
  int qtdProdutos;
  double saldo;
  double empenho;

  AddressTagModel({
    required this.recno,
    required this.departamento,
    required this.apartamento,
    required this.rua,
    required this.predio,
    required this.nivel,
    required this.filial,
    required this.codEndereco,
    required this.descricao,
    required this.armazem,
    required this.qtdProdutos,
    required this.saldo,
    required this.empenho,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'recno': recno,
      'departamento': departamento,
      'apartamento': apartamento,
      'rua': rua,
      'predio': predio,
      'nivel': nivel,
      'filial': filial,
      'codEndereco': codEndereco,
      'descricao': descricao,
      'armazem': armazem,
      'qtdProdutos': qtdProdutos,
      'saldo': saldo,
      'empenho': empenho,
    };
  }

  factory AddressTagModel.fromMap(Map<String, dynamic> map) {
    return AddressTagModel(
      recno: map['recno']?.toInt() ?? 0,
      departamento: map['departamento'] ?? '',
      apartamento: map['apartamento'] ?? '',
      rua: map['rua'] ?? '',
      predio: map['predio'] ?? '',
      nivel: map['nivel'] ?? '',
      filial: map['filial'] ?? '',
      codEndereco: map['codigo_endereco'] ?? '',
      descricao: map['descricao'] ?? '',
      armazem: map['armazem'] ?? '',
      qtdProdutos: map['quant_produtos'] as int,
      saldo: map['saldo']?.toDouble() ?? 0.0,
      empenho: map['empenho']?.toDouble() ?? 0.0,
    );
  }
  String groupbyDepartamento() => "$armazem|$departamento";
  String groupbyDepartamentoRua() => "$armazem|$departamento|$rua";
  String groupbyDepartamentoRuaPredio() =>
      "$armazem|$departamento|$rua|$predio";

  String fullAddress() =>
      "$armazem|$departamento|$rua|$predio|$nivel|$apartamento";

  String toJson() => json.encode(toMap());

  factory AddressTagModel.fromJson(String source) =>
      AddressTagModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

Map<String, dynamic> addressToMap(String address) {
  final list = address.split("|");

  Map<String, dynamic> map = {};

  if (list.length >= 2) {
    map['armazem'] = list[0];
    map['departamento'] = list[1];
  }

  if (list.length >= 3) {
    map['rua'] = list[2];
  }

  if (list.length >= 4) {
    map['predio'] = list[3];
  }

  if (list.length >= 5) {
    map['nivel'] = list[4];
  }

  if (list.length >= 6) {
    map['apartamento'] = list[5];
  }

  return map;
}
