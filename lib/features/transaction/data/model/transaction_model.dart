// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TransactionModel {
  String codigo;
  String local;
  double quantidade;
  String lote;
  String endereco;
  String validade;
  String codcli;
  String lojacli;
  String nomecli;
  String chave;

  TransactionModel(
      {required this.codigo,
      required this.local,
      required this.quantidade,
      required this.lote,
      required this.endereco,
      required this.codcli,
      required this.lojacli,
      required this.nomecli,
      required this.chave,
      required this.validade});

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'local': local,
      'quantidade': quantidade,
      'lote': lote,
      'endereco': endereco,
      'validade': validade,
      'codcli': codcli,
      'lojacli': lojacli,
      'nomecli': nomecli,
      'chave': chave
    };
  }

  @override
  String toString() {
    return 'TransactionModel(codigo: $codigo, local: $local, quantidade: $quantidade, lote: $lote, endereco: $endereco)';
  }

  @override
  bool operator ==(covariant TransactionModel other) {
    if (identical(this, other)) return true;

    return other.codigo == codigo &&
        other.local == local &&
        other.quantidade == quantidade &&
        other.lote == lote &&
        other.endereco == endereco &&
        other.chave == chave;
  }

  @override
  int get hashCode {
    return codigo.hashCode ^
        local.hashCode ^
        quantidade.hashCode ^
        lote.hashCode ^
        endereco.hashCode;
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      codigo: map['codigo'] ?? '',
      local: map['local'] ?? '',
      quantidade: map['quantidade']?.toDouble() ?? 0,
      lote: map['lote'] ?? '',
      endereco: map['endereco'] ?? '',
      validade: map['validade'] ?? '',
      codcli: map['codcli'] ?? '',
      lojacli: map['lojacli'] ?? '',
      nomecli: map['nomecli'] ?? '',
      chave: map['chave'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source));
}
