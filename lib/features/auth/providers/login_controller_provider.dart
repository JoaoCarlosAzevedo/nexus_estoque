import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/auth/providers/login_state.dart';

import '../model/user_model.dart';

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
  return LoginController(ref);
});

class LoginController extends StateNotifier<LoginState> {
  LoginController(this.ref) : super(const LoginStateInitial());

  final Ref ref;

  void login(UserModel user) {
    state = LoginStateSuccess(user);
  }

  void logout() {
    state = const LoginStateInitial();
  }
}
