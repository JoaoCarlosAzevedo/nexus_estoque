import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/auth/providers/login_state.dart';

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
  return LoginController(ref);
});

class LoginController extends StateNotifier<LoginState> {
  LoginController(this.ref) : super(const LoginStateInitial());

  final Ref ref;

  void login() {
    state = const LoginStateSuccess();
  }

  void logout() {
    state = const LoginStateInitial();
  }
}
