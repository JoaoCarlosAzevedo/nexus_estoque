import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/http/config.dart';
import '../../../../core/http/dio_config.dart';
import '../../../../core/http/http_provider.dart';

import '../model/purchase_invoice_model.dart';

final purchaseInvoicesProvider = FutureProvider.autoDispose
    .family<List<PurchaseInvoice>, String>((ref, filter) async {
  final param = filter.split("/");
  final result = await ref
      .read(purchaseInvoiceRepositoryProvider)
      .fetchPurchaseInvoiceList(param[0], param[1]);
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

  Future<bool> postPlateNumber(
      String plateNumber, List<PurchaseInvoice> invoices) async {
    final String url = await Config.baseURL;

    final jsonMap = {
      'placa': plateNumber,
      'nfs': invoices.map((e) => e.toMapRecno()).toList(),
    };

    final json = jsonEncode(jsonMap);

    try {
      var response = await dio.post(
        '$url/conferencia_nf_entrada/placa',
        data: json,
      );
      if (response.statusCode != 201) {
        return false;
      }
      return true;
    } on DioException catch (_) {
      return false;
      //throw (e.error.toString());
    }
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

      if (response.data.runtimeType != List<dynamic>) {
        if (response.data["mensagem"] != null) {
          return Right(invoices);
        }
      }

      final listPurchaseInvoices = (response.data as List).map((item) {
        return PurchaseInvoice.fromMap(item);
      }).toList();

      return Right(listPurchaseInvoices);
    } on DioException catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }

  Future<Either<Failure, List<PurchaseInvoice>>> fetchPurchaseInvoiceList(
      String dayIni, String dayEnd) async {
    final String url = await Config.baseURL;
    try {
      var response =
          await dio.get('$url/conferencia_nf_entrada/lista/', queryParameters: {
        'dataIni': dayIni,
        'dataFim': dayEnd,
        'filtro': " ( (DA3.DA3_COD is not null) or (SF1.F1_PLACA != ' ') ) ",
        //'filtro': 'DA3.DA3_COD is not null',
      });

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      final listPurchaseInvoices = (response.data as List).map((item) {
        return PurchaseInvoice.fromMap(item);
      }).toList();

      return Right(listPurchaseInvoices);
    } on DioException catch (e) {
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }
}
