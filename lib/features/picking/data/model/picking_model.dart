import 'dart:convert';

class PickingModel {
  String descricao;
  double separado;
  String codigobarras;
  String codigobarras2;
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
  String codCli;
  String desCli;
  String rua;

  String descEndereco2;
  String rua2;
  String deposito;
  String predio;
  String nivel;
  String apartamento;

  PickingModel(
      {required this.descricao,
      required this.separado,
      required this.codigobarras,
      required this.codigobarras2,
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
      required this.codCli,
      required this.desCli,
      required this.descEndereco2,
      required this.rua2,
      required this.deposito,
      required this.predio,
      required this.nivel,
      required this.apartamento,
      required this.rua});

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'separado': separado,
      'codigobarras': codigobarras,
      'codigobarras2': codigobarras2,
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
      'codCliente': codCli,
      'descCliente': desCli,
      'descEndereco2': descEndereco2,
      'rua2': rua2,
      'deposito': deposito,
      'predio': predio,
      'nivel': nivel,
      'apartamento': apartamento,
    };
  }

  factory PickingModel.fromMap(Map<String, dynamic> map) {
    return PickingModel(
      descricao: map['descricao'] ?? '',
      separado: map['separado']?.toDouble() ?? 0.0,
      codigobarras: map['codigobarras'] ?? '',
      codigobarras2: map['codigobarras2'] ?? '',
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
      codCli: map['codCliente'] ?? '',
      desCli: map['descCliente'] ?? '',
      rua: map['rua'] ?? '',
      descEndereco2: map['descEnderecov2'] ?? '',
      rua2: map['rua_v2'] ?? '',
      deposito: map['deposito'] ?? '',
      predio: map['predio'] ?? '',
      nivel: map['nivel'] ?? '',
      apartamento: map['aparatamento'] ?? '',
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
