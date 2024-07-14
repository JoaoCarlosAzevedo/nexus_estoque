import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../data/model/filter_tag_load_order_model.dart';
import '../../../data/repositories/filter_tag_order_repository.dart';

part 'filter_tag_load_order_state.dart';

class FilterTagLoadOrderCubit extends Cubit<FilterTagLoadOrderState> {
  final FilterTagRepository repostiory;
  FilterTagLoadOrderCubit(this.repostiory, String load)
      : super(FilterTagLoadInitial()) {
    if (load.isNotEmpty) {
      fetchLoad(load, "", null);
    }
  }

  void setSelectedInvoice(Orders order) {
    if (state is FilterTagLoadLoaded) {
      final currentState = state as FilterTagLoadLoaded;

      emit(FilterTagLoadLoading());
      emit(FilterTagLoadLoaded(
          load: currentState.load,
          selectedInvoice: order,
          error: '',
          etiqueta: ''));
    }
  }

  void addProduct(String barcode) {
    if (state is FilterTagLoadLoaded) {
      selectProduct(barcode, 0, 1);
    }
  }

  void selectProduct(String barcode, double quantity, double add) {
    if (state is FilterTagLoadLoaded) {
      final currentState = state as FilterTagLoadLoaded;
      String error = "";

      if (currentState.selectedInvoice != null) {
        int index = currentState.selectedInvoice!.itens.indexWhere((element) {
          if (element.codigo.trim() == barcode.trim()) {
            return true;
          }

          if (barcode.trim().length >= 5) {
            if (element.codigobarras.trim().contains(barcode.trim())) {
              return true;
            }

            if (element.codigobarras2.trim().contains(barcode.trim())) {
              return true;
            }
          }

          return false;
        });
        if (index != -1) {
          emit(FilterTagLoadLoading());
          final nEtiq =
              currentState.selectedInvoice!.itens[index].quantidaetiqueta;
          final nNfQuant =
              currentState.selectedInvoice!.itens[index].quantidade;
          final nNovaqt =
              currentState.selectedInvoice!.itens[index].novaQuantidade;
          if (add > 0) {
            //verifica se excedeu a quantidade da NF  / ja impresso
            if (nNovaqt + add > (nNfQuant - nEtiq)) {
              error = "Excedeu a quantidade da NF";
            } else {
              currentState.selectedInvoice!.itens[index].novaQuantidade += add;
            }
          } else {
            if (quantity > (nNfQuant - nEtiq)) {
              error = "Excedeu a quantidade da NF";
            } else {
              currentState.selectedInvoice!.itens[index].novaQuantidade =
                  quantity;
            }
          }
          emit(
            FilterTagLoadLoaded(
                load: currentState.load,
                selectedInvoice: currentState.selectedInvoice,
                error: error,
                etiqueta: ''),
          );
        } else {
          emit(FilterTagLoadLoading());
          emit(
            FilterTagLoadLoaded(
                load: currentState.load,
                selectedInvoice: currentState.selectedInvoice,
                error: "Produto não encontrado!",
                etiqueta: ''),
          );
        }
      }
    }
  }

  void postTag() async {
    if (state is FilterTagLoadLoaded) {
      final currentState = state as FilterTagLoadLoaded;
      if (currentState.selectedInvoice != null) {
        emit(FilterTagLoadLoading());
        final result = await repostiory.postTag(currentState.selectedInvoice!);
        if (result.isRight()) {
          result.fold((l) => null, (r) {
            fetchLoad(currentState.load.carga, r, currentState.selectedInvoice);
          });
        } else {
          result.fold((l) => emit(FilterTagLoadError(error: l)), (r) => null);
        }
      }
    }
  }

  void fetchLoad(String load, String etiqueta, Orders? order) async {
    emit(FilterTagLoadLoading());

    final result = await repostiory.fetchLoad(load);
    if (result.isRight()) {
      result.fold((l) => null, (r) {
        if (order != null) {
          final newOrder = r.pedidos.firstWhere(
            (element) => element.pedido.trim() == order.pedido.trim(),
          );
          emit(
            FilterTagLoadLoaded(
                load: r,
                selectedInvoice: newOrder,
                error: '',
                etiqueta: etiqueta),
          );
        } else {
          emit(
            FilterTagLoadLoaded(
                load: r, selectedInvoice: null, error: '', etiqueta: etiqueta),
          );
        }
      });
    } else {
      result.fold((l) => emit(FilterTagLoadError(error: l)), (r) => null);
    }
  }
}
