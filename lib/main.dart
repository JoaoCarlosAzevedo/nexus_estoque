import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/routes/routes.dart';
import 'package:nexus_estoque/core/theme/app_theme.dart';
import 'package:nexus_estoque/features/auth/data/repositories/auth_repository.dart';
import 'package:nexus_estoque/features/auth/pages/login/cubit/auth_cubit.dart';

final FlutterLocalization localization = FlutterLocalization.instance;

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

class NexusEstoque extends ConsumerStatefulWidget {
  const NexusEstoque({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NexusEstoqueState();
}

class _NexusEstoqueState extends ConsumerState<NexusEstoque> {
  @override
  void initState() {
    localization.init(
      mapLocales: [],
      initLanguageCode: 'en',
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final routes = ref.watch(routerProvider);
    return BlocProvider(
      create: (context) => AuthCubit(ref.read(authRepositoryProvider)),
      child: MaterialApp.router(
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: localization.localizationsDelegates,
        theme: AppTheme.defaultTheme,
        debugShowCheckedModeBanner: false,
        routerDelegate: routes.routerDelegate,
        routeInformationParser: routes.routeInformationParser,
        routeInformationProvider: routes.routeInformationProvider,
      ),
    );
  }
}
