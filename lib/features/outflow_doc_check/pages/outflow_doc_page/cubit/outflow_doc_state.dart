part of 'outflow_doc_cubit.dart';

abstract class OutFlowDocState extends Equatable {
  const OutFlowDocState();

  @override
  List<Object> get props => [];
}

class OutFlowDocInitial extends OutFlowDocState {}

class OutFlowDocLoading extends OutFlowDocState {}

class OutFlowDocError extends OutFlowDocState {
  final Failure failure;

  const OutFlowDocError(this.failure);
}

class OutFlowDocLoaded extends OutFlowDocState {
  final OutFlowDoc docs;
  final Produtos? scannedProduct;
  final bool notFound;
  const OutFlowDocLoaded(this.docs, this.scannedProduct, this.notFound);
}
