import 'package:equatable/equatable.dart';

import '../model/user_model.dart';

class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginStateInitial extends LoginState {
  const LoginStateInitial();

  @override
  List<Object> get props => [];
}

class LoginStateLoading extends LoginState {
  const LoginStateLoading();

  @override
  List<Object> get props => [];
}

class LoginStateSuccess extends LoginState {
  final UserModel user;
  const LoginStateSuccess(this.user);

  @override
  List<Object> get props => [];
}

class LoginStateError extends LoginState {
  final String error;

  const LoginStateError(this.error);

  @override
  List<Object> get props => [error];
}
