import 'package:equatable/equatable.dart';

class PalletObsItem extends Equatable {
  final String pedido;
  final String codigo;
  final String descricao;
  final double quantidade;

  const PalletObsItem({
    required this.pedido,
    required this.codigo,
    required this.descricao,
    required this.quantidade,
  });

  Map<String, dynamic> toMap() {
    return {
      'pedido': pedido,
      'codigo': codigo,
      'descricao': descricao,
      'quantidade': quantidade,
    };
  }

  PalletObsItem copyWith({
    String? pedido,
    String? codigo,
    String? descricao,
    double? quantidade,
  }) {
    return PalletObsItem(
      pedido: pedido ?? this.pedido,
      codigo: codigo ?? this.codigo,
      descricao: descricao ?? this.descricao,
      quantidade: quantidade ?? this.quantidade,
    );
  }

  @override
  List<Object?> get props => [pedido, codigo, quantidade];
}
