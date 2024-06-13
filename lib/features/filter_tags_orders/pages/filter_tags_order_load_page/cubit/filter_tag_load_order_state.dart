part of 'filter_tag_order_load_cubit.dart';

abstract class FilterTagLoadOrderState extends Equatable {
  const FilterTagLoadOrderState();

  @override
  List<Object> get props => [];
}

class FilterTagLoadInitial extends FilterTagLoadOrderState {}

class FilterTagLoadLoading extends FilterTagLoadOrderState {}

class FilterTagLoadLoaded extends FilterTagLoadOrderState {
  final String error;
  final String etiqueta;
  final LoadOrder load;
  final Orders? selectedInvoice;
  const FilterTagLoadLoaded(
      {required this.load,
      required this.selectedInvoice,
      required this.error,
      required this.etiqueta});
}

class FilterTagLoadError extends FilterTagLoadOrderState {
  final Failure error;

  const FilterTagLoadError({required this.error});
}
