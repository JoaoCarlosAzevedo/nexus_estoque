import 'dart:convert';

class TransactionModel {
  String codigo;
  String local;
  int quantidade;
  String lote;
  String endereco;
  String tm;

  TransactionModel({
    required this.codigo,
    required this.local,
    required this.quantidade,
    required this.lote,
    required this.endereco,
    required this.tm,
  });

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'local': local,
      'quantidade': quantidade,
      'lote': lote,
      'endereco': endereco,
      'tm': tm,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      codigo: map['codigo'] ?? '',
      local: map['local'] ?? '',
      quantidade: map['quantidade']?.toInt() ?? 0,
      lote: map['lote'] ?? '',
      endereco: map['endereco'] ?? '',
      tm: map['tm'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source));
}
