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

      for (final invoices in currentState.invoices) {
        for (final product in invoices.purchaseInvoiceProducts) {
          if (!product.partial) {
            if (product.checked < product.quantidade) {
              AudioService.error();
              emit(
                PurchaseInvoiceProductsLChecking(
                    show: true,
                    invoices: currentState.invoices,
                    barcode: 'avisoAbaixo',
                    product: product),
              );
              return;
            }
          }
        }
      }

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

  void checkBarcodeOld(String barcode) {
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
            if (element.barcode.trim() == barcode.trim() &&
                (element.checked < element.quantidade)) {
              return true;
            }

            if (element.barcode2.trim() == barcode.trim() &&
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
              if (element.barcode.trim() == barcode.trim()) {
                return true;
              }
            }
            if (barcode.trim().length >= 5) {
              if (element.barcode2.trim() == barcode.trim()) {
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

  void setMultiplier(String barcode, bool switchValue) {
    if (state is PurchaseInvoiceProductsLChecking) {
      final currentState = state as PurchaseInvoiceProductsLChecking;
      var currentInvoices = currentState.invoices;
      final products = currentInvoices.fold(<PurchaseInvoiceProduct>[],
          (previousValue, element) {
        previousValue.addAll(element.purchaseInvoiceProducts);
        return previousValue;
      });

      for (var element in products) {
        if (element.codigo == (barcode)) {
          element.isMultiple = switchValue;
        }
      }
      emit(PurchaseInvoiceProductsLoading());
      emit(PurchaseInvoiceProductsLChecking(
        invoices: currentState.invoices,
        barcode: '',
        product: null,
        show: false,
      ));
    }
  }

  void setProductFator(String sku, double newFator) {
    if (state is PurchaseInvoiceProductsLChecking) {
      final currentState = state as PurchaseInvoiceProductsLChecking;
      var currentInvoices = currentState.invoices;
      final products = currentInvoices.fold(<PurchaseInvoiceProduct>[],
          (previousValue, element) {
        previousValue.addAll(element.purchaseInvoiceProducts);
        return previousValue;
      });

      for (var element in products) {
        if (element.codigo == (sku)) {
          element.fator = newFator;
        }
      }
      emit(PurchaseInvoiceProductsLoading());
      emit(PurchaseInvoiceProductsLChecking(
        invoices: currentState.invoices,
        barcode: '',
        product: null,
        show: false,
      ));
    }
  }

  double checkMultilier(String barcode) {
    double total = 0;
    if (state is PurchaseInvoiceProductsLChecking) {
      final currentState = state as PurchaseInvoiceProductsLChecking;
      var currentInvoices = currentState.invoices;
      final products = currentInvoices.fold(<PurchaseInvoiceProduct>[],
          (previousValue, element) {
        previousValue.addAll(element.purchaseInvoiceProducts);
        return previousValue;
      });

      for (var element in products) {
        if (element.codigo == (barcode) ||
            element.barcode == (barcode) ||
            element.barcode2 == (barcode)) {
          total = total + element.checked;
        }
      }
    }

    return total;
  }

  void setNewQuantity(double newQuantity, PurchaseInvoiceProduct product) {
    if (state is PurchaseInvoiceProductsLChecking) {
      final currentState = state as PurchaseInvoiceProductsLChecking;
      var currentInvoices = currentState.invoices;
      final products = currentInvoices
          .fold(<PurchaseInvoiceProduct>[], (previousValue, element) {
            previousValue.addAll(element.purchaseInvoiceProducts);
            return previousValue;
          })
          .where((element) => element.codigo.trim() == product.codigo.trim())
          .toList();

      double saldo = newQuantity;
      //zera antes de distribuir
      for (var element in products) {
        element.checked = 0;
      }

      for (var produto in products) {
        if (produto.checked < produto.quantidade) {
          //se a quantidade exceder a quantidade do primeiro pedido, preenche como completo e controla o saldo
          if ((saldo + produto.checked) > produto.quantidade) {
            double necessario = produto.quantidade - produto.checked;
            produto.checked = produto.checked + necessario;
            saldo = saldo - necessario;
            //esse produto ja foi atendido
            continue;
          }

          if (saldo > 0) {
            produto.checked = produto.checked + saldo;
            saldo = 0;
          }
        }
      }
      //se ainda sobrou saldo extra, joga no ultimo
      if (saldo > 0) {
        PurchaseInvoiceProduct ultimo = products.last;
        ultimo.checked = ultimo.checked + saldo;
      }

      emit(PurchaseInvoiceProductsLoading());

      if (currentState.product == null) {
        emit(
          PurchaseInvoiceProductsLChecking(
              show: false,
              invoices: currentState.invoices,
              barcode: '',
              product: null),
        );
      } else {
        emit(
          PurchaseInvoiceProductsLChecking(
              show: true,
              invoices: currentInvoices,
              barcode: currentState.product!.barcode,
              product: currentState.product),
        );
      }
    }
  }

  void checkBarcode(String barcode) {
    if (state is PurchaseInvoiceProductsLChecking) {
      final currentState = state as PurchaseInvoiceProductsLChecking;
      var currentInvoices = currentState.invoices;
      final products = currentInvoices.fold(<PurchaseInvoiceProduct>[],
          (previousValue, element) {
        previousValue.addAll(element.purchaseInvoiceProducts);
        return previousValue;
      });
      var found = false;

      int index = products.indexWhere((element) {
        if (element.codigo.trim() == barcode.trim() &&
            (element.checked < element.quantidade)) {
          return true;
        }

        if (barcode.trim().length >= 5) {
          if (element.barcode.trim() == barcode.trim() &&
              (element.checked < element.quantidade)) {
            return true;
          }

          if (element.barcode2.trim() == barcode.trim() &&
              (element.checked < element.quantidade)) {
            return true;
          }
        }
        return false;
      });

      //caso nenhum tenha sido encotrado, procura sem o filtro de checagem completa
      if (index == -1) {
        index = products.indexWhere((element) {
          if (element.codigo.trim() == barcode.trim()) {
            return true;
          }

          if (barcode.trim().length >= 5) {
            if (element.barcode.trim() == barcode.trim()) {
              return true;
            }
          }
          if (barcode.trim().length >= 5) {
            if (element.barcode2.trim() == barcode.trim()) {
              return true;
            }
          }

          return false;
        });
      }

      //emit(PurchaseInvoiceProductsLoading());

      if (index >= 0) {
        bool isDun = false;

        if (products[index].barcode2.trim() == barcode.trim()) {
          isDun = true;
        }

        //if (products[index].isMultiple && products[index].fator > 0) {
        if (isDun && products[index].fator > 0) {
          //products[index].checked += 1 * products[index].fator;
          var checked = checkMultilier(barcode);
          setNewQuantity(
              checked + (1 * products[index].fator), products[index]);
        } else {
          products[index].checked += 1;
        }
        found = true;
        AudioService.beep();
        emit(PurchaseInvoiceProductsLoading());
        emit(
          PurchaseInvoiceProductsLChecking(
              show: true,
              invoices: currentInvoices,
              barcode: barcode.trim(),
              product: products[index]),
        );
      }

      if (!found) {
        //nao encontrou nenhum elemento
        AudioService.error();
        emit(PurchaseInvoiceProductsLoading());
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
