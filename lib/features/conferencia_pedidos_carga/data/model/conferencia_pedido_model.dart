import 'package:nexus_estoque/features/order_check/data/model/order_check_model.dart';

class ConferenciaPedidoModel {
  final String pedido;
  final String cliente;
  final String estado;
  final String municipio;
  final String carga;
  final List<OrderCheckItemModel> itens;

  ConferenciaPedidoModel({
    required this.pedido,
    required this.cliente,
    required this.estado,
    required this.municipio,
    required this.carga,
    required this.itens,
  });

  factory ConferenciaPedidoModel.fromJson(Map<String, dynamic> json) {
    return ConferenciaPedidoModel(
      pedido: json['pedido']?.toString() ?? '',
      cliente: json['cliente']?.toString() ?? '',
      estado: json['estado']?.toString() ?? '',
      municipio: json['municipio']?.toString() ?? '',
      carga: json['carga']?.toString() ?? '',
      itens: (json['itens'] as List<dynamic>?)
              ?.map((item) => OrderCheckItemModel.fromJson(
                    item as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
    );
  }

  ConferenciaPedidoModel copyWith({
    String? pedido,
    String? cliente,
    String? estado,
    String? municipio,
    String? carga,
    List<OrderCheckItemModel>? itens,
  }) {
    return ConferenciaPedidoModel(
      pedido: pedido ?? this.pedido,
      cliente: cliente ?? this.cliente,
      estado: estado ?? this.estado,
      municipio: municipio ?? this.municipio,
      carga: carga ?? this.carga,
      itens: itens ?? this.itens,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConferenciaPedidoModel &&
          runtimeType == other.runtimeType &&
          pedido == other.pedido;

  @override
  int get hashCode => pedido.hashCode;
}
