import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../data/model/filter_tag_order_model.dart';
import '../../../data/repositories/filter_tag_order_repository.dart';

part 'filter_tag_order_state.dart';

class FilterTagOrderCubit extends Cubit<FilterTagOrderState> {
  final FilterTagRepository repository;
  FilterTagOrderCubit(this.repository, pedido)
      : super(FilterTagInvoiceInitial()) {
    fetchFilterTags(pedido);
  }

  void fetchFilterTags(String pedido) async {
    emit(FilterTagInvoiceLoading());

    final result = await repository.fetchAllTags(pedido);

    result.fold((l) => emit(FilterTagInvoiceError(error: l)),
        (r) => emit(FilterTagInvoiceLoaded(tags: r)));
  }

  void deleteTag(FilterTagOrderModel tag) async {
    emit(FilterTagInvoiceLoading());

    final _ = await repository.deleteTag(tag);

    fetchFilterTags(tag.pedido);

    /* result.fold((l) => emit(FilterTagInvoiceError(error: l)),
        (r) => emit(FilterTagInvoiceSuccess())); */
  }
}
