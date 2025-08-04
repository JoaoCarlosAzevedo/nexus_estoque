// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/audio_player.dart';
import '../../../../address_inventory/pages/address_inventory_form_page/state/address_inventory_provider.dart';
import '../../../data/model/volume_order_model.dart';
import '../../../data/repositories/volume_label_repository.dart';

final volumeOrderProvider =
    StateNotifierProvider.autoDispose<VolumeOrderNotifier, VolumeOrderState>(
        (ref) {
  final repository = ref.read(volumeLabelRepository);
  return VolumeOrderNotifier(repository);
});

class VolumeOrderNotifier extends StateNotifier<VolumeOrderState> {
  final VolumeLabelRepository repository;
  VolumeOrderNotifier(this.repository)
      : super(const VolumeOrderState(
            pedido: '',
            numExpedicao: '',
            etiqueta: '',
            error: '',
            orderProducts: [],
            status: StateEnum.initial));

  void checkBarcode(String barcode) async {
    final currState = state.orderProducts;
    int index = currState.indexWhere((element) {
      if (element.codigo.trim() == barcode.trim()) {
        return true;
      }

      if (barcode.trim().length >= 5) {
        if (element.codigo.trim() == barcode.trim()) {
          return true;
        }

        if (element.barcode.trim() == barcode.trim()) {
          return true;
        }
      }

      return false;
    });

    if (index != -1) {
      //state = state.copyWith(status: StateEnum.loading);

      final novaQtd = currState[index].novaQtd;
      final qtdPedido = currState[index].quantPedido;
      final qtdGrav = currState[index].quantVolume;

      if ((novaQtd + 1 + qtdGrav) > qtdPedido) {
        state = state.copyWith(
            error: "Excedeu a quantidade do Pedido", status: StateEnum.error);
        AudioService.error();
        return;
      }
      currState[index] =
          currState[index].copyWith(novaQtd: currState[index].novaQtd + 1);

      state =
          state.copyWith(orderProducts: currState, status: StateEnum.initial);

      AudioService.beep();
    } else {
      state = state.copyWith(
          error: "Produto não encontrado no pedido!", status: StateEnum.error);
      AudioService.error();
    }
  }

  void changeQuantity(String codigo, double newQuantity) {
    final currState = state.orderProducts;
    int index = currState.indexWhere((element) {
      if (element.codigo.trim() == codigo.trim()) {
        return true;
      }
      return false;
    });

    if (index != -1) {
      final qtdPedido = currState[index].quantPedido;
      final qtdGrav = currState[index].quantVolume;

      if ((qtdGrav + newQuantity) > qtdPedido) {
        state = state.copyWith(
            error: "Excedeu a quantidade do Pedido", status: StateEnum.error);
        AudioService.error();
        return;
      }

      currState[index] = currState[index].copyWith(novaQtd: newQuantity);
      state =
          state.copyWith(orderProducts: currState, status: StateEnum.initial);
    }
  }

  void postVolumeLabel() async {
    state = state.copyWith(status: StateEnum.loading);
    final json = {
      'pedido': state.pedido,
      'numExpedicao': state.numExpedicao,
      'itens': state.orderProducts
          .map(
            (e) => {
              'codigo': e.codigo,
              'itemPedido': e.item,
              'barcode': e.barcode,
              'quantidade': e.novaQtd
            },
          )
          .toList(),
    };

    try {
      final String jsonString = jsonEncode(json);
      final etiqueta = await repository.postVolumeLabel(jsonString);

      if (etiqueta.isNotEmpty) {
        state = state.copyWith(etiqueta: etiqueta);
        state = state.copyWith(status: StateEnum.success);
      } else {
        state = state.copyWith(
            error: "Erro ao gerar etiquetas", status: StateEnum.error);
      }
    } catch (e) {
      state = state.copyWith(
          error: "Erro ao gravar etiqueta!", status: StateEnum.error);
    }
  }

  void setInitialState(
      String pedido, String numExpedicao, List<VolumeProdOrderModel> products) {
    state = state.copyWith(
        pedido: pedido,
        numExpedicao: numExpedicao,
        orderProducts: products,
        status: StateEnum.initial);
  }

  //void changeQuantity() {}
}

@immutable
class VolumeOrderState {
  final String pedido;
  final String numExpedicao;
  final String etiqueta;
  final String error;

  final List<VolumeProdOrderModel> orderProducts;

  final StateEnum status;

  const VolumeOrderState(
      {required this.pedido,
      required this.numExpedicao,
      required this.orderProducts,
      required this.status,
      required this.error,
      required this.etiqueta});

  VolumeOrderState copyWith({
    String? pedido,
    String? numExpedicao,
    List<VolumeProdOrderModel>? orderProducts,
    StateEnum? status,
    String? etiqueta,
    String? error,
  }) {
    return VolumeOrderState(
      pedido: pedido ?? this.pedido,
      numExpedicao: numExpedicao ?? this.numExpedicao,
      orderProducts: orderProducts ?? this.orderProducts,
      status: status ?? this.status,
      error: error ?? this.error,
      etiqueta: etiqueta ?? this.etiqueta,
    );
  }
}
