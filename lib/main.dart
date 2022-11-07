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
    const NexusEstoque(),
  );
}

class NexusEstoque extends StatelessWidget {
  const NexusEstoque({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(AuthRepository()),
      child: MaterialApp.router(
        theme: AppTheme.defaultTheme,
        debugShowCheckedModeBanner: false,
        //routerConfig: routes,
        routerDelegate: routes.routerDelegate,
        routeInformationParser: routes.routeInformationParser,
        routeInformationProvider: routes.routeInformationProvider,
      ),
    );
  }
}
