import 'package:flutter/material.dart';

import 'package:nexus_estoque/features/menu/presentantion/pages/menu_page.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) => const MenuPage());
      case "/enderecas":
        return MaterialPageRoute(
<<<<<<< HEAD
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
=======
            builder: (context) => DefaultPage(title: 'Enderecas'));
      case "/movimentos":
        return MaterialPageRoute(
            builder: (context) => DefaultPage(title: 'Movimentos'));
      case "/transferencias":
        return MaterialPageRoute(
            builder: (context) => DefaultPage(title: 'Transferencias'));
      case "/consulta":
        return MaterialPageRoute(
            builder: (context) => DefaultPage(title: 'Consulta'));
      default:
        return MaterialPageRoute(
            builder: (context) => DefaultPage(
>>>>>>> 836e46fccb2825de4e92da095fe60338a7cc2515
                  title: 'defaul',
                ));
    }
  }
}

class DefaultPage extends StatelessWidget {
<<<<<<< HEAD
  final String title;

  const DefaultPage({
=======
  String title;

  DefaultPage({
>>>>>>> 836e46fccb2825de4e92da095fe60338a7cc2515
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
