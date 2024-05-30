import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../data/model/filter_tag_load_model.dart';
import '../../../data/repositories/filter_tag_repository.dart';

part 'filter_tag_load_state.dart';

class FilterTagLoadCubit extends Cubit<FilterTagLoadState> {
  final FilterTagRepository repostiory;
  FilterTagLoadCubit(this.repostiory) : super(FilterTagLoadInitial());

  void setSelectedInvoice(Invoice invoice) {
    if (state is FilterTagLoadLoaded) {
      final currentState = state as FilterTagLoadLoaded;

      emit(FilterTagLoadLoading());
      emit(FilterTagLoadLoaded(
          load: currentState.load, selectedInvoice: invoice));
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
          if (add > 0) {
            currentState.selectedInvoice!.itens[index].novaQuantidade += add;
          } else {
            currentState.selectedInvoice!.itens[index].novaQuantidade =
                quantity;
          }
          emit(FilterTagLoadLoaded(
              load: currentState.load,
              selectedInvoice: currentState.selectedInvoice));
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
            /*  emit(
              FilterTagLoadLoaded(
                  load: currentState.load, selectedInvoice: null),
            ); */
            fetchLoad(currentState.load.carga);
          });
        } else {
          result.fold((l) => emit(FilterTagLoadError(error: l)), (r) => null);
        }
      }
    }
  }

  void fetchLoad(String load) async {
    emit(FilterTagLoadLoading());

    final result = await repostiory.fetchLoad(load);
    if (result.isRight()) {
      result.fold((l) => null, (r) {
        emit(
          FilterTagLoadLoaded(load: r, selectedInvoice: null),
        );
      });
    } else {
      result.fold((l) => emit(FilterTagLoadError(error: l)), (r) => null);
    }
  }
}
