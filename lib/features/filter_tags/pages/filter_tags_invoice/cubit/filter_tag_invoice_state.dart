// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'filter_tag_invoice_cubit.dart';

abstract class FilterTagInvoiceState extends Equatable {
  const FilterTagInvoiceState();

  @override
  List<Object> get props => [];
}

class FilterTagInvoiceInitial extends FilterTagInvoiceState {}

class FilterTagInvoiceSuccess extends FilterTagInvoiceState {}

class FilterTagInvoiceLoading extends FilterTagInvoiceState {}

class FilterTagInvoiceLoaded extends FilterTagInvoiceState {
  final List<FilterTagModel> tags;
  const FilterTagInvoiceLoaded({
    required this.tags,
  });
}

class FilterTagInvoiceError extends FilterTagInvoiceState {
  final Failure error;
  const FilterTagInvoiceError({
    required this.error,
  });
}
