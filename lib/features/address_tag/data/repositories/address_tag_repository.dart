import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/http/config.dart';
import '../../../../core/http/http_provider.dart';
import '../model/address_tag_model.dart';

final remoteAddressTagListProvider =
    FutureProvider.autoDispose<List<AddressTagModel>>((ref) async {
  final result = await ref.read(addressTagRepository).fetchAddresses();
  return result;
});

final remoteAddressTagZplProvider =
    FutureProvider.family.autoDispose<String, String>((ref, arg) async {
  final result = await ref.read(addressTagRepository).fetchAddressTag(arg);
  return result;
});

final addressTagRepository =
    Provider<AddressTagRepository>((ref) => AddressTagRepository(ref));

class AddressTagRepository {
  late Dio dio;
  final Ref _ref;

  AddressTagRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<List<AddressTagModel>> fetchAddresses() async {
    late dynamic response;
    final String url = await Config.baseURL;
    try {
      response =
          await dio.get('$url/nexus/v1/wms_endereco', queryParameters: {});

      if (response.statusCode != 200) {
        throw const Failure("Server Error!", ErrorType.exception);
      }

      if (response.data.isEmpty) {
        throw const Failure(
            "Nenhum registro encontrado.", ErrorType.validation);
      }

      final listAddress = (response.data as List).map((item) {
        return AddressTagModel.fromMap(item);
      }).toList();
      return listAddress;
    } on DioException catch (_) {
      throw const Failure("Server Error!", ErrorType.exception);
    }
  }

  Future<String> fetchAddressTag(String code) async {
    late dynamic response;
    final String url = await Config.baseURL;
    final Map<String, dynamic> map = addressToMap(code);

    try {
      response = await dio.get('$url/nexus/v1/wms_endereco/etiqueta',
          queryParameters: map);

      if (response.statusCode != 200) {
        throw Exception('Server Error!');
      }

      return response.data["etiqueta"];
    } on DioException catch (_) {
      throw const Failure("Server Error!", ErrorType.exception);
    }
  }
}
