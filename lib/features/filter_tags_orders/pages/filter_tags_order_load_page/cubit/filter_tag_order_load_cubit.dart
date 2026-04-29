import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../data/model/filter_tag_load_order_model.dart';
import '../../../data/model/filter_tag_order_model.dart';
import '../../../data/repositories/filter_tag_order_repository.dart';

part 'filter_tag_load_order_state.dart';

class FilterTagLoadOrderCubit extends Cubit<FilterTagLoadOrderState> {
  final FilterTagRepository repostiory;

  /// Quando true, após [postTag]/[postIindividualTag] com sucesso não chama [fetchLoad] (carga).
  final bool skipCargaRefreshAfterPost;

  FilterTagLoadOrderCubit(
    this.repostiory,
    String load, {
    this.skipCargaRefreshAfterPost = false,
  }) : super(FilterTagLoadInitial()) {
    if (load.isNotEmpty) {
      fetchLoad(load, "", null);
    }
  }

  /// Abre a seleção de produtos sem [fetchLoad] inicial (ex.: lista V3 + pedido/completo).
  FilterTagLoadOrderCubit.prefetched(
    this.repostiory, {
    required LoadOrder load,
    required Orders selectedInvoice,
    List<FilterTagOrderModel> etiquetas = const [],
    this.skipCargaRefreshAfterPost = false,
  }) : super(
          FilterTagLoadLoaded(
            load: load,
            selectedInvoice: selectedInvoice,
            error: '',
            etiqueta: '',
            etiquetas: etiquetas,
          ),
        );

  void setSelectedInvoice(Orders order) {
    if (state is FilterTagLoadLoaded) {
      final currentState = state as FilterTagLoadLoaded;

      emit(FilterTagLoadLoading());
      emit(FilterTagLoadLoaded(
          load: currentState.load,
          selectedInvoice: order,
          error: '',
          etiqueta: '',
          etiquetas: currentState.etiquetas));
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
            if (element.codigobarras.trim() == barcode.trim()) {
              return true;
            }

            if (element.codigobarras2.trim() == barcode.trim()) {
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
                etiqueta: '',
                etiquetas: currentState.etiquetas),
          );
        } else {
          emit(FilterTagLoadLoading());
          emit(
            FilterTagLoadLoaded(
                load: currentState.load,
                selectedInvoice: currentState.selectedInvoice,
                error: "Produto não encontrado!",
                etiqueta: '',
                etiquetas: currentState.etiquetas),
          );
        }
      }
    }
  }

  void postTag(String order) async {
    if (state is FilterTagLoadLoaded) {
      final currentState = state as FilterTagLoadLoaded;
      if (currentState.selectedInvoice != null) {
        emit(FilterTagLoadLoading());
        final result = await repostiory.postTag(currentState.selectedInvoice!);
        if (result.isRight()) {
          result.fold((l) => null, (r) {
            _afterTagPostSuccess(currentState, order, r);
          });
        } else {
          result.fold((l) => emit(FilterTagLoadError(error: l)), (r) => null);
        }
      }
    }
  }

  void postIindividualTag(String order) async {
    if (state is FilterTagLoadLoaded) {
      final currentState = state as FilterTagLoadLoaded;
      if (currentState.selectedInvoice != null) {
        emit(FilterTagLoadLoading());

        final result =
            await repostiory.postIndividualTag(currentState.selectedInvoice!);
        if (result.isRight()) {
          result.fold((l) => null, (r) {
            _afterTagPostSuccess(currentState, order, r);
          });
        } else {
          result.fold((l) => emit(FilterTagLoadError(error: l)), (r) => null);
        }
      }
    }
  }

  void _afterTagPostSuccess(
    FilterTagLoadLoaded currentState,
    String order,
    String etiquetaZpl,
  ) {
    if (skipCargaRefreshAfterPost) {
      emit(
        FilterTagLoadLoaded(
          load: currentState.load,
          selectedInvoice: currentState.selectedInvoice,
          error: '',
          etiqueta: etiquetaZpl,
          etiquetas: currentState.etiquetas,
        ),
      );
      return;
    }
    fetchLoad(
      order.isEmpty ? currentState.load.carga : order,
      etiquetaZpl,
      currentState.selectedInvoice,
    );
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
                etiqueta: etiqueta,
                etiquetas: const []),
          );
        } else {
          emit(
            FilterTagLoadLoaded(
                load: r,
                selectedInvoice: null,
                error: '',
                etiqueta: etiqueta,
                etiquetas: const []),
          );
        }
      });
    } else {
      result.fold((l) => emit(FilterTagLoadError(error: l)), (r) => null);
    }
  }
}
