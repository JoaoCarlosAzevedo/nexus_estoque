// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OrderLabelModel {
  final String pedido;
  final int volumes;
  final String cliente;
  List<ProductOrderLabelModel> products;

  OrderLabelModel({
    required this.pedido,
    required this.volumes,
    required this.products,
    required this.cliente,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pedido': pedido,
      'volumes': volumes,
      'products': products.map((x) => x.toMap()).toList(),
    };
  }

  bool verificarCodigoOuBarcode(String valor) {
    return products
        .any((item) => item.codigo == valor || item.barcode == valor);
  }

  factory OrderLabelModel.fromMap(Map<String, dynamic> map) {
    return OrderLabelModel(
      pedido: map['pedido'] ?? '',
      cliente: map['cliente'] ?? '',
      volumes: map['volumes']?.toInt() ?? 0,
      products: List<ProductOrderLabelModel>.from(
        map['produtos']?.map(
          (x) => ProductOrderLabelModel.fromMap(x),
        ),
      ),
    );
  }

  /* 
  List<VolumeProdOrderModel>.from(
        map['produtos']?.map(
          (x) => VolumeProdOrderModel.fromMap(x),
        ),
      ),
   */

  String toJson() => json.encode(toMap());

  factory OrderLabelModel.fromJson(String source) =>
      OrderLabelModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ProductOrderLabelModel {
  final String item;
  final String codigo;
  final String descricao;
  final String barcode;
  final double quant;

  ProductOrderLabelModel({
    required this.item,
    required this.codigo,
    required this.descricao,
    required this.barcode,
    required this.quant,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'item': item,
      'codigo': codigo,
      'descricao': descricao,
      'barcode': barcode,
      'quant': quant,
    };
  }

  factory ProductOrderLabelModel.fromMap(Map<String, dynamic> map) {
    return ProductOrderLabelModel(
      item: map['item'] ?? '',
      codigo: map['codigo'] ?? '',
      descricao: map['descricao'] ?? '',
      barcode: map['barcode'] ?? '',
      quant: map['quant']?.toDouble() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductOrderLabelModel.fromJson(String source) =>
      ProductOrderLabelModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
