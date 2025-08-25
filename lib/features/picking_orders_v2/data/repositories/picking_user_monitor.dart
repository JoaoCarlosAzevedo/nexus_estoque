import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/dio_config.dart';

import 'package:nexus_estoque/core/http/http_provider.dart';

import '../model/picking_monitor_model.dart';

final pickingUserMonitorRepositoryProvider =
    Provider<PickingUserMonitorRepository>(
        (ref) => PickingUserMonitorRepository(ref));

final fetchUserMonitorProvider =
    FutureProvider.autoDispose<PickingMonitorModel>(
  (ref) async {
    final repository = ref.read(pickingUserMonitorRepositoryProvider);
    return await repository.fetchUserMonitor();
  },
);

final postInitPickingProvider = StateNotifierProvider.autoDispose<
    PostInitPickingNotifier, AsyncValue<bool>>(
  (ref) =>
      PostInitPickingNotifier(ref.read(pickingUserMonitorRepositoryProvider)),
);

final postStartPickingProvider = StateNotifierProvider.autoDispose<
    PostStartPickingNotifier, AsyncValue<bool>>(
  (ref) =>
      PostStartPickingNotifier(ref.read(pickingUserMonitorRepositoryProvider)),
);

class PostInitPickingNotifier extends StateNotifier<AsyncValue<bool>> {
  final PickingUserMonitorRepository _repository;

  PostInitPickingNotifier(this._repository)
      : super(const AsyncValue.data(false));

  Future<void> postEndPicking(String order, String tipoLancamento) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.postEndPicking(order, tipoLancamento);
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

class PostStartPickingNotifier extends StateNotifier<AsyncValue<bool>> {
  final PickingUserMonitorRepository _repository;

  PostStartPickingNotifier(this._repository)
      : super(const AsyncValue.data(false));

  Future<void> postInitPicking(String order) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.postInitPicking(order);
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

class PickingUserMonitorRepository {
  late Dio dio;
  final Ref _ref;
  final options = DioConfig.dioBaseOption;

  PickingUserMonitorRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<bool> postInitPicking(String order) async {
    final String url = await Config.baseURL;

    final jsonList = {
      'tipo_lancamento': "Inicio Separacao",
      'operador': '',
      'chave': order
    };

    final String json = jsonEncode(jsonList);

    try {
      var response = await dio.post(
        '$url/api/wms/v1/monitor_user',
        data: json,
      );

      if (response.statusCode != 201) {
        return false;
      }

      return true;
    } on DioException catch (e) {
      if (e.type.name == "connectTimeout") {
        throw "Tempo Excedido";
      }

      if (e.response!.data["errorMessage"] != "") {
        throw e.response!.data["errorMessage"];
      }
      throw "Server Error!";
    }
  }

  Future<bool> postEndPicking(String order, String tipoLancamento) async {
    final String url = await Config.baseURL;

    final jsonList = {
      'tipo_lancamento': tipoLancamento,
      'operador': '',
      'chave': order
    };

    final String json = jsonEncode(jsonList);

    try {
      var response = await dio.post(
        '$url/api/wms/v1/monitor_user',
        data: json,
      );

      if (response.statusCode != 201) {
        return false;
      }

      return true;
    } on DioException catch (e) {
      if (e.type.name == "connectTimeout") {
        throw "Tempo Excedido";
      }

      if (e.response!.data["errorMessage"] != "") {
        throw e.response!.data["errorMessage"];
      }
      throw "Server Error!";
    }
  }

  Future<PickingMonitorModel> fetchUserMonitor() async {
    final String url = await Config.baseURL;
    try {
      var response = await dio.get('$url/api/wms/v1/monitor_user');

      if (response.statusCode != 200) {
        throw 'Erro ao buscar separação em andamento';
      }

      if (response.data.isEmpty) {
        throw 'Erro ao buscar separação em andamento!';
      }

      //return response.data["chave"];
      return PickingMonitorModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.type.name == "connectTimeout") {
        throw "Tempo Excedido";
      }
      throw "Server Error!";
    }
  }
}
