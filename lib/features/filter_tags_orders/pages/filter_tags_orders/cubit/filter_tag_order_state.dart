// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'filter_tag_order_cubit.dart';

abstract class FilterTagOrderState extends Equatable {
  const FilterTagOrderState();

  @override
  List<Object> get props => [];
}

class FilterTagInvoiceInitial extends FilterTagOrderState {}

class FilterTagInvoiceSuccess extends FilterTagOrderState {}

class FilterTagInvoiceLoading extends FilterTagOrderState {}

class FilterTagInvoiceLoaded extends FilterTagOrderState {
  final List<FilterTagOrderModel> tags;
  const FilterTagInvoiceLoaded({
    required this.tags,
  });
}

class FilterTagInvoiceError extends FilterTagOrderState {
  final Failure error;
  const FilterTagInvoiceError({
    required this.error,
  });
}
