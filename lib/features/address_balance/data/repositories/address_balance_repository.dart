import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';
import 'package:nexus_estoque/features/address_balance/data/model/address_balance_model.dart';

final addressBalanceRepositoryProvider =
    Provider<AddressBalanceRepository>((ref) => AddressBalanceRepository(ref));

class AddressBalanceRepository {
  late Dio dio;
  final Ref _ref;
  final options = DioConfig.dioBaseOption;

  AddressBalanceRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<Either<Failure, List<AddressBalanceModel>>> fetchAddressBalance(
      String address) async {
    final String url = await Config.baseURL;
    try {
      var response = await dio.get('$url/produtos/saldos/endereco/$address');

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      if (response.data.isEmpty) {
        return const Left(Failure("Nao Encontrado!", ErrorType.validation));
      }
      final listAdressBalances = (response.data as List).map((item) {
        return AddressBalanceModel.fromMap(item);
      }).toList();

      return Right(listAdressBalances);
    } on DioException catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }
}
