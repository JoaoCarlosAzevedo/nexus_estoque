import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/routes/routes.dart';
import 'package:nexus_estoque/core/theme/app_theme.dart';
import 'package:nexus_estoque/features/auth/data/repositories/auth_repository.dart';
import 'package:nexus_estoque/features/auth/presentation/pages/login/cubit/auth_cubit.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  //splashscreen
  await Future.delayed(
    const Duration(seconds: 1),
    () => true,
  );

  runApp(
    const ProviderScope(child: NexusEstoque()),
  );
}

class NexusEstoque extends ConsumerWidget {
  const NexusEstoque({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(routerProvider);
    return BlocProvider(
      create: (context) => AuthCubit(ref.read(authRepository)),
      child: MaterialApp.router(
        theme: AppTheme.defaultTheme,
        debugShowCheckedModeBanner: false,
        routerDelegate: routes.routerDelegate,
        routeInformationParser: routes.routeInformationParser,
        routeInformationProvider: routes.routeInformationProvider,
      ),
    );
  }
}
