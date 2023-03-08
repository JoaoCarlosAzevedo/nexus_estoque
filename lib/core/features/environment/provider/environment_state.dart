import 'package:equatable/equatable.dart';

abstract class EnvironmentState extends Equatable {
  const EnvironmentState();

  @override
  List<Object> get props => [];
}

class EnvironmentLoadingURL extends EnvironmentState {
  const EnvironmentLoadingURL();

  @override
  List<Object> get props => [];
}

class EnvironmentWithURL extends EnvironmentState {
  final String url;
  const EnvironmentWithURL(this.url);

  @override
  List<Object> get props => [];
}

class EnvironmentWithoutURL extends EnvironmentState {
  const EnvironmentWithoutURL();

  @override
  List<Object> get props => [];
}
