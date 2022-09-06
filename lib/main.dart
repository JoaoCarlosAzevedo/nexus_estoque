import 'package:flutter/material.dart';
import 'package:nexus_estoque/core/theme/theme.dart';
import 'core/routes/routes.dart';

void main() {
  runApp(
    NexusEstoque(
      router: AppRouter(),
    ),
  );
}

class NexusEstoque extends StatelessWidget {
  final AppRouter router;

  const NexusEstoque({Key? key, required this.router}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router.generateRoute,
    );
  }
}
