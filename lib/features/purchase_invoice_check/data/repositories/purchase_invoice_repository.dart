import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/http/config.dart';
import '../../../../core/http/dio_config.dart';
import '../../../../core/http/http_provider.dart';
import '../../../../core/utils/datetime_formatter.dart';
import '../model/purchase_invoice_model.dart';

final purchaseInvoicesProvider =
    FutureProvider.autoDispose<List<PurchaseInvoice>>((ref) async {
  final result = await ref
      .read(purchaseInvoiceRepositoryProvider)
      .fetchPurchaseInvoiceList();
  return result.fold((l) => Future.error('Error na API'), (r) => r);
});

final purchaseInvoiceRepositoryProvider = Provider<PurchaseInvoiceRepository>(
    (ref) => PurchaseInvoiceRepository(ref));

class PurchaseInvoiceRepository {
  late Dio dio;
  final Ref _ref;
  final options = DioConfig.dioBaseOption;

  PurchaseInvoiceRepository(this._ref) {
    dio = _ref.read(httpProvider).dioInstance;
  }

  Future<Either<Failure, List<PurchaseInvoice>>> postPurchaseInvoicesChecked(
      List<PurchaseInvoice> invoices) async {
    final String url = await Config.baseURL;

    List<Map<String, dynamic>> jsonData =
        invoices.map((e) => e.toMap()).toList();
    final json = jsonEncode(jsonData);

    try {
      var response = await dio.post(
        '$url/conferencia_nf_entrada/',
        data: json,
      );

      if (response.statusCode != 201) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      final listPurchaseInvoices = (response.data as List).map((item) {
        return PurchaseInvoice.fromMap(item);
      }).toList();

      return Right(listPurchaseInvoices);
    } on DioError catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }

  Future<Either<Failure, List<PurchaseInvoice>>>
      fetchPurchaseInvoiceList() async {
    final String url = await Config.baseURL;
    try {
      var response =
          await dio.get('$url/conferencia_nf_entrada/lista/', queryParameters: {
        /*    'dataIni': datetimeToYYYYMMDD(DateTime.now()),
        'dataFim': datetimeToYYYYMMDD(DateTime.now()),
        'filtro': 'DA3.DA3_COD is not null', */

        'dataIni': '20240517',
        'dataFim': '20240517',
        'filtro': 'DA3.DA3_COD is not null',
      });

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      final listPurchaseInvoices = (response.data as List).map((item) {
        return PurchaseInvoice.fromMap(item);
      }).toList();

      return Right(listPurchaseInvoices);
    } on DioError catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }
}
