import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nexus_estoque/core/theme/app_theme.dart';
import 'package:nexus_estoque/features/auth/data/repositories/auth_repository.dart';
import 'package:nexus_estoque/features/auth/presentation/pages/login/cubit/auth_cubit.dart';
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
    return BlocProvider(
      create: (context) => AuthCubit(AuthRepository()),
      child: MaterialApp(
        theme: AppTheme.defaultTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: router.generateRoute,
      ),
    );
  }
}
