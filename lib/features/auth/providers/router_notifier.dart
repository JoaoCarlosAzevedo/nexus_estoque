import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/auth/providers/login_controller_provider.dart';
import 'package:nexus_estoque/features/auth/providers/login_state.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<LoginState>(
      loginControllerProvider,
      (_, __) => notifyListeners(),
    );
  }
}
