import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/import_invoice_repository.dart';

final importInvoiceProvider =
    AsyncNotifierProvider.autoDispose<ImportInvoiceProvider, bool>(
  ImportInvoiceProvider.new,
);

class ImportInvoiceProvider extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() => false;

  Future<void> fetchImportInvoice(String chave) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(importInvoiceRepositoryProvider);
      await repository.fechtImportInvoice(chave);
      return true;
    });
  }
}
