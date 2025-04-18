import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/import_invoice_repository.dart';

final importInvoiceProvider =
    AutoDisposeAsyncNotifierProvider<ImportInvoiceProvider, bool>(() {
  return ImportInvoiceProvider();
});

class ImportInvoiceProvider extends AutoDisposeAsyncNotifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<void> fetchImportInvoice(String chave) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(importInvoiceRepositoryProvider);
      await repository.fechtImportInvoice(chave);
      return true;
    });
  }
}
