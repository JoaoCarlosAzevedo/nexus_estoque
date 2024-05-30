part of 'filter_tag_load_cubit.dart';

abstract class FilterTagLoadState extends Equatable {
  const FilterTagLoadState();

  @override
  List<Object> get props => [];
}

class FilterTagLoadInitial extends FilterTagLoadState {}

class FilterTagLoadLoading extends FilterTagLoadState {}

class FilterTagLoadLoaded extends FilterTagLoadState {
  final Load load;
  final Invoice? selectedInvoice;
  const FilterTagLoadLoaded(
      {required this.load, required this.selectedInvoice});
}

class FilterTagLoadError extends FilterTagLoadState {
  final Failure error;

  const FilterTagLoadError({required this.error});
}
