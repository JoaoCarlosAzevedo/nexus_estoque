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
    route: 'enderecar',
  ),
  MenuItemInfo(
    title: "Transferências",
    icon: FontAwesomeIcons.cartFlatbed,
    color: Colors.red,
    route: 'transferencias',
  ),
  /*  MenuItemInfo(
    title: "Movimentos Internos",
    icon: FontAwesomeIcons.boxesPacking,
    color: Colors.red,
    route: 'movimentos',
  ), */
  MenuItemInfo(
    title: "Separação",
    icon: FontAwesomeIcons.dolly,
    color: Colors.red,
    route: 'separacao',
  ),
  MenuItemInfo(
    title: "Conferencia NFe Saida",
    icon: FontAwesomeIcons.rightFromBracket,
    color: Colors.red,
    route: 'saidacheck',
  ),
/*   MenuItemInfo(
    title: "Conferencia NFe Entrada",
    icon: FontAwesomeIcons.rightToBracket,
    color: Colors.red,
    route: 'entradaCheck',
  ), */
];
