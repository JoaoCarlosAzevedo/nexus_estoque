import 'dart:convert';

class EtiquetaNfSaidaStatus {
  final String filial;
  final String notaFiscal;
  final String serie;
  final String codigoCliente;
  final String lojaCliente;
  final String nomeCliente;
  final String codigoTransp;
  final String nomeTransp;
  final String chaveNFe;
  final List<EtiquetaNfSaidaStatusProduto> produtos;

  const EtiquetaNfSaidaStatus({
    required this.filial,
    required this.notaFiscal,
    required this.serie,
    required this.codigoCliente,
    required this.lojaCliente,
    required this.nomeCliente,
    required this.codigoTransp,
    required this.nomeTransp,
    required this.chaveNFe,
    required this.produtos,
  });

  int get qtdItens => produtos.length;

  Map<String, dynamic> toMap() {
    return {
      'filial': filial,
      'NotaFiscal': notaFiscal,
      'Serie': serie,
      'CodigoCliente': codigoCliente,
      'LojaCliente': lojaCliente,
      'NomeCliente': nomeCliente,
      'CodigoTransp': codigoTransp,
      'NomeTransp': nomeTransp,
      'ChaveNFe': chaveNFe,
      'produtos': produtos.map((e) => e.toMap()).toList(),
    };
  }

  factory EtiquetaNfSaidaStatus.fromMap(Map<String, dynamic> map) {
    return EtiquetaNfSaidaStatus(
      filial: map['filial']?.toString() ?? '',
      notaFiscal: map['NotaFiscal']?.toString() ?? '',
      serie: map['Serie']?.toString() ?? '',
      codigoCliente: map['CodigoCliente']?.toString() ?? '',
      lojaCliente: map['LojaCliente']?.toString() ?? '',
      nomeCliente: map['NomeCliente']?.toString() ?? '',
      codigoTransp: map['CodigoTransp']?.toString() ?? '',
      nomeTransp: map['NomeTransp']?.toString() ?? '',
      chaveNFe: map['ChaveNFe']?.toString() ?? '',
      produtos: (map['produtos'] as List?)
              ?.map((e) => EtiquetaNfSaidaStatusProduto.fromMap(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  String toJson() => json.encode(toMap());

  factory EtiquetaNfSaidaStatus.fromJson(String source) =>
      EtiquetaNfSaidaStatus.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class EtiquetaNfSaidaStatusProduto {
  final String codigo;
  final String descricao;
  final String item;
  final double quantidade;
  final double fator;
  final String barcode;
  final String barcode2;
  final String um;
  final double checked;
  final String dataConf;
  final String horaConf;
  final String userConf;
  final String obsPedido;

  const EtiquetaNfSaidaStatusProduto({
    required this.codigo,
    required this.descricao,
    required this.item,
    required this.quantidade,
    required this.fator,
    required this.barcode,
    required this.barcode2,
    required this.um,
    required this.checked,
    required this.dataConf,
    required this.horaConf,
    required this.userConf,
    required this.obsPedido,
  });

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'descricao': descricao,
      'item': item,
      'quantidade': quantidade,
      'fator': fator,
      'barcode': barcode,
      'barcode2': barcode2,
      'um': um,
      'checked': checked,
      'dataConf': dataConf,
      'horaConf': horaConf,
      'userConf': userConf,
      'obs_pedido': obsPedido,
    };
  }

  factory EtiquetaNfSaidaStatusProduto.fromMap(Map<String, dynamic> map) {
    return EtiquetaNfSaidaStatusProduto(
      codigo: map['codigo']?.toString() ?? '',
      descricao: map['descricao']?.toString() ?? '',
      item: map['item']?.toString() ?? '',
      quantidade: (map['quantidade'] as num?)?.toDouble() ?? 0,
      fator: (map['fator'] as num?)?.toDouble() ?? 0,
      barcode: map['barcode']?.toString() ?? '',
      barcode2: map['barcode2']?.toString() ?? '',
      um: map['um']?.toString() ?? '',
      checked: (map['checked'] as num?)?.toDouble() ?? 0,
      dataConf: map['dataConf']?.toString() ?? '',
      horaConf: map['horaConf']?.toString() ?? '',
      userConf: map['userConf']?.toString() ?? '',
      obsPedido: map['obs_pedido']?.toString() ?? '',
    );
  }
}
