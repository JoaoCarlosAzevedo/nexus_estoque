// ignore_for_file: unnecessary_const

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/outflow_doc_check/data/model/outflow_doc_model.dart';
import 'package:nexus_estoque/features/outflow_doc_check/data/repositories/outflow_doc_repository.dart';

import '../../../../../core/services/audio_player.dart';

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
        String error = "";
        final currState = state as OutFlowDocLoaded;
        emit(OutFlowDocLoading());
        //caso faz a coleta de uma etiqueta, busca os produtos;
        final result = await repository.fetchFilterTag(code);
        if (result.isRight()) {
          result.fold((l) => null, (r) {
            final products = r;
            for (var productTag in products) {
              int index = currState.docs.produtos.indexWhere((element) {
                if (element.codigo.trim() == productTag.produto.trim()) {
                  return true;
                }
                return false;
              });

              if (index >= 0) {
                currState.docs.produtos[index].checked += productTag.quatidade;
                if (currState.docs.produtos[index].checked >
                    currState.docs.produtos[index].quantidade) {
                  error =
                      "Produto: ${currState.docs.produtos[index].descricao.trim()} Conferido ${currState.docs.produtos[index].checked} de ${currState.docs.produtos[index].quantidade}";
                  break;
                }
              } else {
                error =
                    "Produto ${productTag.descricao.trim()} não encontrado na NF";
                break;
              }
            }
          });

          if (error.isNotEmpty) {
            AudioService.error();
            emit(OutFlowDocError(Failure(error, ErrorType.validation)));
            emit(OutFlowDocLoaded(currState.docs, null, false, code));
            return;
          }

          AudioService.beep();
          emit(OutFlowDocLoaded(currState.docs, null, false, code));
        } else {
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
            if (element.barcode.trim().contains(code.trim()) &&
                (element.checked < element.quantidade)) {
              return true;
            }

            if (element.barcode2.trim().contains(code.trim()) &&
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
              if (element.barcode.trim().contains(code.trim())) {
                return true;
              }
            }
            if (code.trim().length >= 5) {
              if (element.barcode2.trim().contains(code.trim())) {
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
}
