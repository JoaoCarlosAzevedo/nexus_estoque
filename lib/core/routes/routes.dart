import 'package:flutter/material.dart';

import 'package:nexus_estoque/features/menu/presentantion/pages/menu_page.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) => const MenuPage());
      case "/enderecas":
        return MaterialPageRoute(
            builder: (context) => const DefaultPage(title: 'Enderecas'));
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
            builder: (context) => const DefaultPage(
                  title: 'defaul',
                ));
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
