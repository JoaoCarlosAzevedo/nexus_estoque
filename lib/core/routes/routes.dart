import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_estoque/features/address/data/repositories/product_address_repository.dart';
import 'package:nexus_estoque/features/address/presentation/pages/address_list_page/address_page.dart';
import 'package:nexus_estoque/features/address/presentation/pages/address_list_page/cubit/product_address_cubit.dart';

import 'package:nexus_estoque/features/menu/presentantion/pages/menu_page.dart';

class AppRouter {
  late ProductAddressRepository productAddressRepository;
  late ProductAddressCubit productAddresCubit;
  AppRouter() {
    productAddressRepository = ProductAddressRepository();
    productAddresCubit = ProductAddressCubit(productAddressRepository);
  }
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) => const MenuPage());
      case "/enderecas":
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: productAddresCubit,
            child: const AddressPage(),
          ),
        );
      case "/movimentos":
        return MaterialPageRoute(
            builder: (context) => const DefaultPage(title: 'Movimentos'));
      case "/transferencias":
        return MaterialPageRoute(
            builder: (context) => const DefaultPage(title: 'Transferencias'));
      case "/consulta":
        return MaterialPageRoute(
            builder: (context) => const DefaultPage(title: 'Consulta'));
      case "/configuracoes":
        return MaterialPageRoute(
            builder: (context) => const DefaultPage(title: 'Configuracoes'));
      default:
        return MaterialPageRoute(
            builder: (context) => const DefaultPage(title: 'Default'));
    }
  }
}

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
