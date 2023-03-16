import 'dart:convert';

class PickingModel {
  String descricao;
  double separado;
  String codigobarras;
  double quantidade;
  String lote;
  String codEndereco;
  String descEndereco;
  String pedido;
  String itemPedido;
  String local;
  String origem;
  String um;
  String codigo;
  String chave;

  PickingModel({
    required this.descricao,
    required this.separado,
    required this.codigobarras,
    required this.quantidade,
    required this.lote,
    required this.codEndereco,
    required this.descEndereco,
    required this.pedido,
    required this.itemPedido,
    required this.local,
    required this.origem,
    required this.um,
    required this.codigo,
    required this.chave,
  });

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'separado': separado,
      'codigobarras': codigobarras,
      'quantidade': quantidade,
      'lote': lote,
      'codEndereco': codEndereco,
      'descEndereco': descEndereco,
      'pedido': pedido,
      'itemPedido': itemPedido,
      'local': local,
      'origem': origem,
      'um': um,
      'codigo': codigo,
      'chaveSDC': chave,
    };
  }

  factory PickingModel.fromMap(Map<String, dynamic> map) {
    return PickingModel(
      descricao: map['descricao'] ?? '',
      separado: map['separado']?.toDouble() ?? 0.0,
      codigobarras: map['codigobarras'] ?? '',
      quantidade: map['quantidade']?.toDouble() ?? 0.0,
      lote: map['lote'] ?? '',
      codEndereco: map['codEndereco'] ?? '',
      descEndereco: map['descEndereco'] ?? '',
      pedido: map['pedido'] ?? '',
      itemPedido: map['itemPedido'] ?? '',
      local: map['local'] ?? '',
      origem: map['origem'] ?? '',
      um: map['um'] ?? '',
      codigo: map['codigo'] ?? '',
      chave: map['chaveSDC'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PickingModel.fromJson(String source) =>
      PickingModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PickingModel(descricao: $descricao, separado: $separado, codigobarras: $codigobarras, quantidade: $quantidade, lote: $lote, codEndereco: $codEndereco, descEndereco: $descEndereco, pedido: $pedido, itemPedido: $itemPedido, local: $local, origem: $origem, um: $um, codigo: $codigo)';
  }
}
