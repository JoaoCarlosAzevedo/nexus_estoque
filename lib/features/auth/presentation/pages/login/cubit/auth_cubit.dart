import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/auth/data/repositories/auth_repository.dart';
import 'package:nexus_estoque/features/auth/model/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;
  AuthCubit(this.repository) : super(AuthInitial());

  void login(String username, String password) async {
    emit(AuthLoading());

    final result = await repository.auth(username, password);

    result.fold((l) => emit(AuthError(l)), (r) => AuthLoaded(r));
  }

  void logout() {
    emit(AuthInitial());
  }
}
