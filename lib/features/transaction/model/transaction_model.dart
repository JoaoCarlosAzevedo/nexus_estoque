// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TransactionModel {
  String codigo;
  String local;
  int quantidade;
  String lote;
  String endereco;
  TransactionModel({
    required this.codigo,
    required this.local,
    required this.quantidade,
    required this.lote,
    required this.endereco,
  });

  TransactionModel copyWith({
    String? codigo,
    String? local,
    int? quantidade,
    String? lote,
    String? endereco,
  }) {
    return TransactionModel(
      codigo: codigo ?? this.codigo,
      local: local ?? this.local,
      quantidade: quantidade ?? this.quantidade,
      lote: lote ?? this.lote,
      endereco: endereco ?? this.endereco,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codigo': codigo,
      'local': local,
      'quantidade': quantidade,
      'lote': lote,
      'endereco': endereco,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      codigo: map['codigo'] as String,
      local: map['local'] as String,
      quantidade: map['quantidade'] as int,
      lote: map['lote'] as String,
      endereco: map['endereco'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);

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
        other.endereco == endereco;
  }

  @override
  int get hashCode {
    return codigo.hashCode ^
        local.hashCode ^
        quantidade.hashCode ^
        lote.hashCode ^
        endereco.hashCode;
  }
}
