import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/services/audio_player.dart';
import '../../../data/model/purchase_invoice_model.dart';
import '../../../data/repositories/purchase_invoice_repository.dart';

part 'purchase_invoice_products_state.dart';

class PurchaseInvoiceProductsCubit extends Cubit<PurchaseInvoiceProductsState> {
  final List<PurchaseInvoice> invoices;
  final PurchaseInvoiceRepository repository;
  PurchaseInvoiceProductsCubit(this.invoices, this.repository)
      : super(PurchaseInvoiceProductsLChecking(
          invoices: invoices,
          barcode: '',
          product: null,
          show: false,
        ));

  void postPurchaseInvoiceCheck() async {
    if (state is PurchaseInvoiceProductsLChecking) {
      final currentState = state as PurchaseInvoiceProductsLChecking;

      emit(PurchaseInvoiceProductsLoading());

      final result =
          await repository.postPurchaseInvoicesChecked(currentState.invoices);

      if (result.isRight()) {
        result.fold((l) => null, (r) {
          emit(PurchaseInvoiceProductsSuccess());
        });
      } else {
        result.fold(
            (l) => emit(PurchaseInvoiceProductsError(error: l)), (r) => null);

        emit(PurchaseInvoiceProductsLChecking(
          invoices: currentState.invoices,
          barcode: '',
          product: null,
          show: false,
        ));
      }
    }
  }

  void checkBarcode(String barcode) {
    if (state is PurchaseInvoiceProductsLChecking) {
      final currentState = state as PurchaseInvoiceProductsLChecking;
      var currentInvoices = currentState.invoices;
      var found = false;
      for (var element in currentInvoices) {
        //busca apenas q nao foram completados
        int index = element.purchaseInvoiceProducts.indexWhere((element) {
          if (element.codigo.trim() == barcode.trim() &&
              (element.checked < element.quantidade)) {
            return true;
          }

          if (barcode.trim().length >= 5) {
            if (element.barcode.trim().contains(barcode.trim()) &&
                (element.checked < element.quantidade)) {
              return true;
            }

            if (element.barcode2.trim().contains(barcode.trim()) &&
                (element.checked < element.quantidade)) {
              return true;
            }
          }

          return false;
        });

        //caso nenhum tenha sido encotrado, procura sem o filtro de checagem completa
        if (index == -1) {
          index = element.purchaseInvoiceProducts.indexWhere((element) {
            if (element.codigo.trim() == barcode.trim()) {
              return true;
            }

            if (barcode.trim().length >= 5) {
              if (element.barcode.trim().contains(barcode.trim())) {
                return true;
              }
            }
            if (barcode.trim().length >= 5) {
              if (element.barcode2.trim().contains(barcode.trim())) {
                return true;
              }
            }

            return false;
          });
        }

        emit(PurchaseInvoiceProductsLoading());
        if (index >= 0) {
          element.purchaseInvoiceProducts[index].checked += 1;
          found = true;
          AudioService.beep();
          emit(
            PurchaseInvoiceProductsLChecking(
                show: true,
                invoices: currentInvoices,
                barcode: barcode.trim(),
                product: element.purchaseInvoiceProducts[index]),
          );
          break;
        }
      }
      if (!found) {
        //nao encontrou nenhum elemento
        AudioService.error();
        emit(
          PurchaseInvoiceProductsLChecking(
              show: true,
              invoices: currentInvoices,
              barcode: barcode.trim(),
              product: null),
        );
      }
    }
  }

  void setProductQuantity(PurchaseInvoiceProduct product, double quantity) {
    if (state is PurchaseInvoiceProductsLChecking) {
      final currentState = state as PurchaseInvoiceProductsLChecking;
      product.checked = quantity;
      emit(PurchaseInvoiceProductsLoading());
      emit(
        PurchaseInvoiceProductsLChecking(
            show: true,
            invoices: currentState.invoices,
            barcode: currentState.barcode,
            product: currentState.product),
      );
    }
  }

  void reset() {
    if (state is PurchaseInvoiceProductsLChecking) {
      final currentState = state as PurchaseInvoiceProductsLChecking;
      emit(PurchaseInvoiceProductsLoading());
      emit(
        PurchaseInvoiceProductsLChecking(
            show: false,
            invoices: currentState.invoices,
            barcode: '',
            product: null),
      );
    }
  }
}
