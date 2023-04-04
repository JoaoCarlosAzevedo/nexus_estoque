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
  final List<OutFlowDoc> docs;
  const OutFlowDocLoaded(this.docs);
}
