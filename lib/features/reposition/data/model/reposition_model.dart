import 'dart:convert';

class RepositionModel {
  final String local;
  final String codEndereco;
  final String descEndereco;
  final String codProduto;
  final String descProduto;
  final String um;
  final int volume;
  final double quant;
  final String codEnderecoRetira;
  final String descEnderecoRetira;
  final double disponivel;
  final double quantAbastecer;

  RepositionModel({
    required this.local,
    required this.codEndereco,
    required this.descEndereco,
    required this.codProduto,
    required this.descProduto,
    required this.um,
    required this.volume,
    required this.quant,
    required this.codEnderecoRetira,
    required this.descEnderecoRetira,
    required this.disponivel,
    required this.quantAbastecer,
  });

  Map<String, dynamic> toMap() {
    return {
      'local': local,
      'codEndereco': codEndereco,
      'descEndereco': descEndereco,
      'codProduto': codProduto,
      'descProduto': descProduto,
      'UM': um,
      'volume': volume,
      'quant': quant,
      'codEnderecoRetira': codEnderecoRetira,
      'descEnderecoRetira': descEnderecoRetira,
      'disponivel': disponivel,
      'quantAbastecer': quantAbastecer,
    };
  }

  factory RepositionModel.fromMap(Map<String, dynamic> map) {
    return RepositionModel(
      local: map['local'] ?? '',
      codEndereco: map['codEndereco'] ?? '',
      descEndereco: map['descEndereco'] ?? '',
      codProduto: map['codProduto'] ?? '',
      descProduto: map['descProduto'] ?? '',
      um: map['UM'] ?? '',
      volume: map['volume']?.toInt() ?? 0,
      quant: map['quant']?.toDouble() ?? 0.0,
      codEnderecoRetira: map['codEnderecoRetira'] ?? '',
      descEnderecoRetira: map['descEnderecoRetira'] ?? '',
      disponivel: map['disponivel']?.toDouble() ?? 0.0,
      quantAbastecer: map['quantAbastecer']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory RepositionModel.fromJson(String source) =>
      RepositionModel.fromMap(json.decode(source));
}
