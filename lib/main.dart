import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/routes/routes.dart';
import 'package:nexus_estoque/core/services/bt_printer.dart';
import 'package:nexus_estoque/core/services/print_config.dart';
import 'package:nexus_estoque/core/theme/app_theme.dart';
import 'package:nexus_estoque/features/auth/data/repositories/auth_repository.dart';
import 'package:nexus_estoque/features/auth/pages/login/cubit/auth_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  void dispose() {
    _disconnectPrinterIfBluetooth();
    super.dispose();
  }

  Future<void> _disconnectPrinterIfBluetooth() async {
    try {
      final mode = await PrintConfig.getMode();
      if (mode == PrintMode.bluetooth) {
        await BluetoothPrinter.disconnect();
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final routes = ref.watch(routerProvider);
    return BlocProvider(
      create: (context) => AuthCubit(ref.read(authRepositoryProvider)),
      child: MaterialApp.router(
        theme: AppTheme.defaultTheme,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'),
        ],
        debugShowCheckedModeBanner: false,
        routerDelegate: routes.routerDelegate,
        routeInformationParser: routes.routeInformationParser,
        routeInformationProvider: routes.routeInformationProvider,
      ),
    );
  }
}
