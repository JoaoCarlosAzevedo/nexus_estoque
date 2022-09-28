import 'package:equatable/equatable.dart';

enum ErrorType { validation, exception, timeout }

class Failure extends Equatable {
  final String error;
  final ErrorType errorType;

  const Failure(this.error, this.errorType);

  @override
  List<Object> get props => [error];
}
