import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';

import '../model/order_label_model.dart';
import '../model/volume_order_model.dart';

final volumeLabelRepository =
    Provider<VolumeLabelRepository>((ref) => VolumeLabelRepository(ref));

final volumeLabelGetOrderProvider = FutureProvider.family
    .autoDispose<VolumeLabelOrder, String>((ref, args) async {
  final result =
      await ref.read(volumeLabelRepository).getVolumeLabelOrder(args);
  return result;
});
final volumeLabelDeleteProvider =
    FutureProvider.family.autoDispose<String, String>((ref, args) async {
  final result = await ref.read(volumeLabelRepository).deleteVolumeLabel(args);
  return result;
});

final orderLabelListProvider =
    FutureProvider.autoDispose<List<OrderLabelModel>>((ref) async {
  final result = await ref.read(volumeLabelRepository).gerOrders();
  return result;
});

class VolumeLabelRepository {
  late Dio dio;
  final Ref _ref;
  final options = DioConfig.dioBaseOption;

  VolumeLabelRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<VolumeLabelOrder> getVolumeLabelOrder(String order) async {
    final String url = await Config.baseURL;
    try {
      final response =
          await dio.get('$url/etiquetas_volumes/pedido', queryParameters: {
        'pedido': order,
      });

      if (response.data.isEmpty) {
        throw const Failure(
            "Nenhum registro encontrado.", ErrorType.validation);
      }

      if (response.statusCode == 200) {
        return VolumeLabelOrder.fromMap(response.data);
      } else {
        throw const Failure(
            "Nenhum registro encontrado.", ErrorType.validation);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Failure(e.response?.data["message"], ErrorType.validation);
      }
      throw const Failure("Server Error!", ErrorType.exception);
    }
  }

  Future<List<OrderLabelModel>> gerOrders() async {
    final String url = await Config.baseURL;
    try {
      final response = await dio.get('$url/etiquetas_volumes/lista/pedidos');

      if (response.data.isEmpty) {
        throw const Failure(
            "Nenhum registro encontrado.", ErrorType.validation);
      }

      if (response.statusCode == 200) {
        final list = (response.data as List).map((item) {
          return OrderLabelModel.fromMap(item);
        }).toList();
        return list;

        //return VolumeLabelOrder.fromMap(response.data);
      } else {
        throw const Failure(
            "Nenhum registro encontrado.", ErrorType.validation);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Failure(e.response?.data["message"], ErrorType.validation);
      }
      throw const Failure("Server Error!", ErrorType.exception);
    }
  }

  Future<List<OrderLabelModel>> gerOrdersByClient(
      String dateIni, String dateFim) async {
    final String url = await Config.baseURL;
    try {
      final response = await dio
          .get('$url/etiquetas_volumes/lista/pedidos', queryParameters: {
        'dtini': dateIni,
        'dtfim': dateFim,
      });

      if (response.data.isEmpty) {
        throw const Failure(
            "Nenhum registro encontrado.", ErrorType.validation);
      }

      if (response.statusCode == 200) {
        final list = (response.data as List).map((item) {
          return OrderLabelModel.fromMap(item);
        }).toList();
        return list;

        //return VolumeLabelOrder.fromMap(response.data);
      } else {
        throw const Failure(
            "Nenhum registro encontrado.", ErrorType.validation);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Failure(e.response?.data["message"], ErrorType.validation);
      }
      throw const Failure("Server Error!", ErrorType.exception);
    }
  }

  Future<String> deleteVolumeLabel(String data) async {
    final String url = await Config.baseURL;
    final param = data.split("|");
    try {
      var response =
          await dio.delete('$url/etiquetas_volumes/', queryParameters: {
        'pedido': param[0],
        'numexp': param[1],
        'volume': param[2],
      });

      if (response.statusCode != 200) {
        throw const Failure("Erro ao excluir etiqueta.", ErrorType.validation);
      }

      return "Etiqueta excluída com sucesso.";
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Failure(e.response?.data["message"], ErrorType.validation);
      }
      throw const Failure("Server Error!", ErrorType.exception);
    }
  }

  Future<String> postVolumeLabel(String json) async {
    final String url = await Config.baseURL;
    try {
      var response = await dio.post('$url/etiquetas_volumes/', data: json);

      if (response.statusCode != 201) {
        throw const Failure("Erro ao gravar etiqueta.", ErrorType.validation);
      }

      if (response.data.isEmpty) {
        throw const Failure("Erro ao gravar etiqueta.", ErrorType.validation);
      }

      return response.data['etiqueta'];
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Failure(e.response?.data["message"], ErrorType.validation);
      }
      throw const Failure("Server Error!", ErrorType.exception);
    }
  }
}
