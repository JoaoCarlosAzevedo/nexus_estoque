import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_estoque/core/pages/searches/address/page/address_search_page.dart';
import 'package:nexus_estoque/core/pages/searches/products/pages/products_search_page.dart';
import 'package:nexus_estoque/core/pages/searches/warehouses/pages/warehouse_search_page.dart';
import 'package:nexus_estoque/features/address/data/model/product_address_model.dart';
import 'package:nexus_estoque/features/address/presentation/pages/address_list_page/address_page.dart';
import 'package:nexus_estoque/features/address/presentation/pages/product_address_form_page/address_form_page.dart';
import 'package:nexus_estoque/features/auth/presentation/pages/login/login_page.dart';
import 'package:nexus_estoque/features/auth/providers/login_controller_provider.dart';
import 'package:nexus_estoque/features/auth/providers/login_state.dart';
import 'package:nexus_estoque/features/auth/providers/router_notifier.dart';
import 'package:nexus_estoque/features/menu/presentantion/pages/menu_page.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_selection/product_transfer_page.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_selection/product_selection_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authService = RouterNotifier(ref);
  return GoRouter(
      debugLogDiagnostics: true,
      initialLocation: '/',
      refreshListenable: authService,
      redirect: (context, state) {
        //final isAuthenticated = authService.isAuthenticated;
        final loginState = ref.read(loginControllerProvider);
        final isLoginRoute = state.subloc == '/';

        if (loginState is LoginStateInitial) {
          return isLoginRoute ? null : '/';
        }

        if (isLoginRoute) return '/menu';

        return null;
      },
      errorBuilder: (context, state) =>
          DefaultPage(title: state.error.toString()),
      routes: [
        GoRoute(path: "/", builder: ((context, state) => const LoginPage())),
        GoRoute(path: "/menu", builder: ((context, state) => const MenuPage())),
        GoRoute(
            path: "/enderecar",
            builder: ((context, state) => const AddressPage())),
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
            path: "/transferencias",
            builder: ((context, state) => const ProductSelectionPage())),
        GoRoute(
            path: "/enderecos/:armazem",
            builder: ((context, state) {
              final param = state.params['armazem'];
              return AddressSearchPage(
                warehouse: param!,
              );
            })),
        GoRoute(
            path: "/produtos",
            builder: ((context, state) => const ProductSearchPage())),
        GoRoute(
            path: "/produtos/saldos/:barcode",
            builder: ((context, state) {
              final param = state.params['barcode'];
              return ProductSelectionForm(
                barcode: param!,
              );
            })),
        GoRoute(
            path: "/armazem",
            builder: ((context, state) => const WarehouseSearchPage())),
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
