// ignore_for_file: unnecessary_const

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/outflow_doc_check/data/model/outflow_doc_model.dart';
import 'package:nexus_estoque/features/outflow_doc_check/data/repositories/outflow_doc_repository.dart';

import '../../../../../core/services/audio_player.dart';
import '../../../../filter_tags/data/model/filter_tag_model.dart';

part 'outflow_doc_state.dart';

class OutFlowDocCubit extends Cubit<OutFlowDocState> {
  final OutflowDocRepository repository;
  OutFlowDocCubit(this.repository) : super(OutFlowDocInitial());

  void fetchOutFlowDoc(String search) async {
    emit(OutFlowDocLoading());

    final result = await repository.fetchOutflowDoc(search);

    if (result.isRight()) {
      result.fold((l) => null, (r) {
        emit(
          OutFlowDocLoaded(r, null, false, null),
        );
      });
    } else {
      result.fold((l) => emit(OutFlowDocError(l)), (r) => null);
    }
  }

  void postOutFlowDoc(OutFlowDoc doc) async {
    emit(OutFlowDocLoading());

    for (final product in doc.produtos) {
      if (product.checked < product.quantidade) {
        emit(const OutFlowDocPostError(Failure(
            "Existem produtos com conferência INFERIOR a NF",
            ErrorType.validation)));

        emit(OutFlowDocLoaded(doc, null, false, null));
        return;
      }

      if (product.checked > product.quantidade) {
        emit(const OutFlowDocPostError(Failure(
            "Existem produtos com conferência SUPERIOR a NF",
            ErrorType.validation)));
        emit(OutFlowDocLoaded(doc, null, false, null));
        return;
      }
    }

    try {
      final result = await repository.postOutFlowDoc(doc);
      if (result.isRight()) {
        result.fold((l) => null, (r) {
          emit(OutFlowDocInitial());
        });
      } else {
        result.fold((l) {
          emit(OutFlowDocPostError(l));
          emit(OutFlowDocLoaded(doc, null, false, null));
        }, (r) => null);
      }
    } catch (e) {
      emit(
        const OutFlowDocPostError(
            Failure("Erro desconhecido", ErrorType.validation)),
      );
      emit(OutFlowDocLoaded(doc, null, false, null));
    }
  }

  void reset() {
    if (state is OutFlowDocLoaded) {
      final aux = state as OutFlowDocLoaded;
      emit(OutFlowDocLoading());
      emit(OutFlowDocLoaded(aux.docs, null, false, null));
    }
  }

  void setProductCheck(int index, double checked) {
    if (state is OutFlowDocLoaded) {
      final aux = state as OutFlowDocLoaded;

      aux.docs.produtos[index].checked = checked;

      emit(OutFlowDocLoading());
      emit(OutFlowDocLoaded(aux.docs, null, false, null));
    }
  }

  void checkProduct(String code) async {
    if (state is OutFlowDocLoaded) {
      if (code.startsWith("ETIQ/")) {
        final currState = state as OutFlowDocLoaded;
        emit(OutFlowDocLoading());
        //caso faz a coleta de uma etiqueta, busca os produtos;
        final result = await repository.fetchFilterTag(code);
        if (result.isRight()) {
          result.fold((l) => null, (r) {
            //volta o estado anterior
            String error = "";
            late FilterTagProductModel checkedProd;
            emit(currState);

            final products = r;

            for (var productTag in products) {
              error = checkProducts(productTag.produto.trim(), true, currState,
                  productTag.quatidade);
              if (error.isNotEmpty) {
                checkedProd = productTag;
                break;
              }
              checkedProd = productTag;
            }

            GroupedProducts grouped = GroupedProducts(
                produto: checkedProd.produto,
                descricao: checkedProd.descricao,
                barcode1: checkedProd.produto,
                barcode2: checkedProd.produto,
                products: []);

            final listProds = currState.docs.produtos
                .where((elemente) =>
                    elemente.codigo.trim() == grouped.produto.trim())
                .toList();

            grouped.products = listProds;

            if (error.isNotEmpty) {
              AudioService.error();
              emit(OutFlowDocError(Failure(error, ErrorType.validation)));
              emit(OutFlowDocLoaded(currState.docs, grouped, false, code));
              return;
            }

            emit(OutFlowDocLoading());
            AudioService.beep();
            emit(OutFlowDocLoaded(currState.docs, grouped, false, code));
          });

          //AudioService.beep();
          //emit(OutFlowDocLoaded(currState.docs, null, false, code));
        } else {
          emit(OutFlowDocLoading());
          AudioService.error();
          emit(OutFlowDocLoaded(currState.docs, null, true, code));
        }
      } else {
        final aux = state as OutFlowDocLoaded;
        int index = aux.docs.produtos.indexWhere((element) {
          if (element.codigo.trim() == code.trim() &&
              (element.checked < element.quantidade)) {
            return true;
          }

          if (code.trim().length >= 5) {
            if (element.barcode.trim() == code.trim() &&
                (element.checked < element.quantidade)) {
              return true;
            }

            if (element.barcode2.trim() == code.trim() &&
                (element.checked < element.quantidade)) {
              return true;
            }
          }

          return false;
        });

        if (index == -1) {
          index = aux.docs.produtos.indexWhere((element) {
            if (element.codigo.trim() == code.trim()) {
              return true;
            }

            if (code.trim().length >= 5) {
              if (element.barcode.trim() == code.trim()) {
                return true;
              }
            }
            if (code.trim().length >= 5) {
              if (element.barcode2.trim() == code.trim()) {
                return true;
              }
            }

            return false;
          });
        }

        emit(OutFlowDocLoading());
        if (index >= 0) {
          aux.docs.produtos[index].checked += 1;

          GroupedProducts grouped = GroupedProducts(
              produto: aux.docs.produtos[index].codigo,
              descricao: aux.docs.produtos[index].descricao,
              barcode1: aux.docs.produtos[index].barcode,
              barcode2: aux.docs.produtos[index].barcode2,
              products: []);

          final listProds = aux.docs.produtos
              .where((elemente) =>
                  elemente.codigo.trim() == grouped.produto.trim())
              .toList();

          grouped.products = listProds;

          AudioService.beep();
          emit(OutFlowDocLoaded(aux.docs, grouped, false, code));
        } else {
          AudioService.error();
          emit(OutFlowDocLoaded(aux.docs, null, true, code));
        }
      }
    }
  }

  String checkProducts(
      String code, bool isTag, OutFlowDocLoaded aux, double checked) {
    //final aux = state as OutFlowDocLoaded;
    double checkSaldo = checked;
    double distribuido = 0;

    int index = aux.docs.produtos.indexWhere((element) {
      if (element.codigo.trim() == code.trim() &&
          (element.checked < element.quantidade)) {
        return true;
      }

      if (code.trim().length >= 5) {
        if (element.barcode.trim() == code.trim() &&
            (element.checked < element.quantidade)) {
          return true;
        }

        if (element.barcode2.trim() == code.trim() &&
            (element.checked < element.quantidade)) {
          return true;
        }
      }

      return false;
    });

    if (index == -1) {
      index = aux.docs.produtos.indexWhere((element) {
        if (element.codigo.trim() == code.trim()) {
          return true;
        }

        if (code.trim().length >= 5) {
          if (element.barcode.trim() == code.trim()) {
            return true;
          }
        }
        if (code.trim().length >= 5) {
          if (element.barcode2.trim() == code.trim()) {
            return true;
          }
        }

        return false;
      });
    }

    if (index >= 0) {
      distribuido = aux.docs.produtos[index].quantidade -
          aux.docs.produtos[index].checked;

      //se a quantidade a distribuir é menor q o necessario, confere apenas a diferenca
      if ((distribuido < checked) && distribuido > 0) {
        checkSaldo = checkSaldo - distribuido;
        aux.docs.produtos[index].checked += distribuido;
      } else {
        //caso contrario confere o total conferido
        aux.docs.produtos[index].checked += checked;
        checkSaldo = 0;
      }
      //existe ainda saldo a ser distribuido
      if (checkSaldo > 0) {
        return checkProducts(code, true, aux, checkSaldo);
      }

      GroupedProducts grouped = GroupedProducts(
          produto: aux.docs.produtos[index].codigo,
          descricao: aux.docs.produtos[index].descricao,
          barcode1: aux.docs.produtos[index].barcode,
          barcode2: aux.docs.produtos[index].barcode2,
          products: []);

      final listProds = aux.docs.produtos
          .where((elemente) => elemente.codigo.trim() == grouped.produto.trim())
          .toList();

      grouped.products = listProds;

      if (aux.docs.produtos[index].checked >
          aux.docs.produtos[index].quantidade) {
        return "Produto ${aux.docs.produtos[index].descricao} excedeu a quantidade! ";
      }

      //emit(OutFlowDocLoaded(aux.docs, grouped, false, code));
      return "";
    } else {
      return "Produto ${code.trim()} não encontrado na NF";
    }
  }
}
