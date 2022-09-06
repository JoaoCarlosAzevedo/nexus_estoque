import 'package:flutter/material.dart';
import 'package:nexus_estoque/features/menu/presentantion/pages/menu_page.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) => const MenuPage());
      default:
        return MaterialPageRoute(builder: (context) => const Scaffold());
    }
  }
}
