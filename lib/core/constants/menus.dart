import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuItemInfo {
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  MenuItemInfo(
      {required this.icon,
      required this.title,
      required this.color,
      required this.route});
}

final List menuItens = [
  MenuItemInfo(
    title: "Endereçar Saldos",
    icon: FontAwesomeIcons.warehouse,
    color: Colors.red,
    route: 'enderecas',
  ),
  MenuItemInfo(
    title: "Movimentos Internos",
    icon: FontAwesomeIcons.boxOpen,
    color: Colors.red,
    route: 'movimentos',
  ),
  MenuItemInfo(
    title: "Transferencias",
    icon: FontAwesomeIcons.boxesPacking,
    color: Colors.red,
    route: 'transferencias',
  ),
  MenuItemInfo(
    title: "Consulta Saldos",
    icon: FontAwesomeIcons.clipboardCheck,
    color: Colors.red,
    route: 'consulta',
  ),
];
