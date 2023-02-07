import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_estoque/core/features/searches/addresses/page/address_search_page.dart';
import 'package:nexus_estoque/core/features/searches/products/pages/products_search_page.dart';
import 'package:nexus_estoque/features/address/data/model/product_address_model.dart';
import 'package:nexus_estoque/features/address/data/repositories/product_address_repository.dart';
import 'package:nexus_estoque/features/address/pages/address_list_page/address_page.dart';
import 'package:nexus_estoque/features/address/pages/address_list_page/cubit/product_address_cubit.dart';
import 'package:nexus_estoque/features/address/pages/product_address_form_page/address_form_page.dart';
import 'package:nexus_estoque/features/auth/pages/login/login_page.dart';
import 'package:nexus_estoque/features/auth/providers/login_controller_provider.dart';
import 'package:nexus_estoque/features/auth/providers/login_state.dart';
import 'package:nexus_estoque/features/auth/providers/router_notifier.dart';
import 'package:nexus_estoque/features/menu/presentation/pages/menu_page.dart';
import 'package:nexus_estoque/features/transaction/pages/transaction_form_page/transaction_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authService = RouterNotifier(ref);
  return GoRouter(
      debugLogDiagnostics: true,
      initialLocation: '/',
      refreshListenable: authService,
      redirect: (context, state) {
        //final isAuthenticated = authService.isAuthenticated;
        final loginState = ref.read(loginControllerProvider);
        final isLoginRoute = state.subloc == '/login';

        if (loginState is LoginStateInitial) {
          return isLoginRoute ? null : '/login';
        }

        if (isLoginRoute) return '/';

        return null;
      },
      errorBuilder: (context, state) =>
          DefaultPage(title: state.error.toString()),
      routes: [
        GoRoute(path: "/", builder: ((context, state) => const MenuPage())),
        GoRoute(
            path: "/login", builder: ((context, state) => const LoginPage())),
        GoRoute(
            path: "/enderecar",
            builder: ((context, state) => BlocProvider(
                  create: (context) =>
                      ProductAddressCubit(ref.read(productAddressRepository)),
                  child: const AddressPage(),
                ))),
        GoRoute(
          path: "/enderecar/form",
          builder: ((context, state) {
            final param = state.extra as ProductAddressModel;
            return AddressForm(
              productAddress: param,
            );
          }),
        ),
        GoRoute(
            path: "/enderecos/:armazem",
            builder: ((context, state) {
              final param = state.params['armazem'];
              return AddressSearchPage(
                warehouse: param!,
                data: const [],
              );
            })),
        GoRoute(
            path: "/produtos",
            builder: ((context, state) => const ProductSearchPage())),
        /*      GoRoute(
            path: "/armazem",
            builder: ((context, state) => const WarehouseSearchPage())), */
        GoRoute(
            path: "/movimentos",
            builder: ((context, state) => const ProductTransactionPage())),
        GoRoute(
            path: "/configuracoes",
            builder: ((context, state) =>
                const DefaultPage(title: 'Configuracoes'))),
      ]);
});

class DefaultPage extends StatelessWidget {
  final String title;

  const DefaultPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(title),
      ),
    );
  }
}
