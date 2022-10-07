import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nexus_estoque/core/theme/app_theme.dart';
import 'core/routes/routes.dart';

void main() async {
  await dotenv.load(fileName: ".env");

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
      theme: AppTheme.defaultTheme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router.generateRoute,
    );
  }
}
