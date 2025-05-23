// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'volume_label_model.dart';

class VolumeLabelOrder {
  List<VolumeProdOrderModel> produtos;
  List<VolumeLabelModel> etiquetas;

  VolumeLabelOrder({
    required this.produtos,
    required this.etiquetas,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'produtos': produtos.map((x) => x.toMap()).toList(),
      'etiquetas': etiquetas.map((x) => x.toMap()).toList(),
    };
  }

  factory VolumeLabelOrder.fromMap(Map<String, dynamic> map) {
    return VolumeLabelOrder(
      produtos: List<VolumeProdOrderModel>.from(
        map['produtos']?.map(
          (x) => VolumeProdOrderModel.fromMap(x),
        ),
      ),
      etiquetas: List<VolumeLabelModel>.from(
        map['etiquetas']?.map(
          (x) => VolumeLabelModel.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory VolumeLabelOrder.fromJson(String source) =>
      VolumeLabelOrder.fromMap(json.decode(source) as Map<String, dynamic>);
}

class VolumeProdOrderModel {
  String pedido;
  String item;
  String numExp;
  double quantPedido;
  String nf;

  String codigo;
  String barcode;
  String descricao;
  String volume;
  double quantVolume;
  double novaQtd;

  VolumeProdOrderModel(
      {required this.pedido,
      required this.item,
      required this.numExp,
      required this.quantPedido,
      required this.nf,
      required this.codigo,
      required this.barcode,
      required this.descricao,
      required this.volume,
      required this.quantVolume,
      required this.novaQtd});

  Map<String, dynamic> toMap() {
    return {
      'pedido': pedido,
      'item': item,
      'numExp': numExp,
      'quantPedido': quantPedido,
      'nf': nf,
      'codigo': codigo,
      'descricao': descricao,
      'volume': volume,
      'quantVolumes': quantVolume,
      'quantidade': novaQtd,
    };
  }

  /// Gera uma chave de agrupamento ignorando o campo `volume` e `quantVolume`
  String groupingKey() {
    return '$pedido|$item|$numExp|$quantPedido|$nf|$codigo|$barcode|$descricao';
  }

  factory VolumeProdOrderModel.fromMap(Map<String, dynamic> map) {
    return VolumeProdOrderModel(
      pedido: map['pedido'] ?? '',
      item: map['item'] ?? '',
      numExp: map['numExp'] ?? '',
      quantPedido: map['quantPedido']?.toDouble() ?? 0,
      nf: map['nf'] ?? '',
      codigo: map['codigo'] ?? '',
      barcode: map['barcode'] ?? '',
      descricao: map['descricao'] ?? '',
      volume: map['volume'] ?? '',
      novaQtd: 0,
      quantVolume: map['quantVolumes']?.toDouble() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory VolumeProdOrderModel.fromJson(String source) =>
      VolumeProdOrderModel.fromMap(json.decode(source));

  VolumeProdOrderModel copyWith({
    String? pedido,
    String? item,
    String? numExp,
    double? quantPedido,
    String? nf,
    String? codigo,
    String? barcode,
    String? descricao,
    String? volume,
    double? quantVolume,
    double? novaQtd,
  }) {
    return VolumeProdOrderModel(
      pedido: pedido ?? this.pedido,
      item: item ?? this.item,
      numExp: numExp ?? this.numExp,
      quantPedido: quantPedido ?? this.quantPedido,
      nf: nf ?? this.nf,
      codigo: codigo ?? this.codigo,
      barcode: barcode ?? this.barcode,
      descricao: descricao ?? this.descricao,
      volume: volume ?? this.volume,
      quantVolume: quantVolume ?? this.quantVolume,
      novaQtd: novaQtd ?? this.novaQtd,
    );
  }
}

List<VolumeProdOrderModel> agruparVolumes(List<VolumeProdOrderModel> lista) {
  final Map<String, VolumeProdOrderModel> agrupados = {};

  for (var item in lista) {
    final chave = item.groupingKey();

    if (agrupados.containsKey(chave)) {
      agrupados[chave]!.quantVolume += item.quantVolume;
    } else {
      // Clona o item (sem considerar o campo volume)
      agrupados[chave] = VolumeProdOrderModel(
        pedido: item.pedido,
        item: item.item,
        numExp: item.numExp,
        quantPedido: item.quantPedido,
        nf: item.nf,
        codigo: item.codigo,
        barcode: item.barcode,
        descricao: item.descricao,
        novaQtd: item.novaQtd,
        volume: item.volume, // Pode manter o primeiro volume encontrado
        quantVolume: item.quantVolume,
      );
    }
  }

  return agrupados.values.toList();
}
