import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../data/model/filter_tag_model.dart';
import '../../../data/repositories/filter_tag_repository.dart';

part 'filter_tag_invoice_state.dart';

class FilterTagInvoiceCubit extends Cubit<FilterTagInvoiceState> {
  final FilterTagRepository repository;
  FilterTagInvoiceCubit(this.repository, nf, serie)
      : super(FilterTagInvoiceInitial()) {
    fetchFilterTags(nf, serie);
  }

  void fetchFilterTags(String nf, String serie) async {
    emit(FilterTagInvoiceLoading());

    final result = await repository.fetchAllTags(nf, serie);

    result.fold((l) => emit(FilterTagInvoiceError(error: l)),
        (r) => emit(FilterTagInvoiceLoaded(tags: r)));
  }

  void deleteTag(FilterTagModel tag) async {
    emit(FilterTagInvoiceLoading());

    final result = await repository.deleteTag(tag);

    fetchFilterTags(tag.nf, tag.serie);

    /* result.fold((l) => emit(FilterTagInvoiceError(error: l)),
        (r) => emit(FilterTagInvoiceSuccess())); */
  }
}
