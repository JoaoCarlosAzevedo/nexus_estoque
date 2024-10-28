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
    title: "Separação por Pedido",
    icon: FontAwesomeIcons.dolly,
    color: Colors.red,
    route: 'separacao',
  ),
  /*
  MenuItemInfo(
    title: "Separação por Rotas",
    icon: FontAwesomeIcons.truckRampBox,
    color: Colors.red,
    route: 'separacao_rotas',
  ),
   MenuItemInfo(
    title: "Separação por Carga",
    icon: FontAwesomeIcons.truckArrowRight,
    color: Colors.red,
    route: 'separacao_carga',
  ), */
  MenuItemInfo(
    title: "Separação por Carga v2",
    icon: FontAwesomeIcons.truckArrowRight,
    color: Colors.red,
    route: 'separacao_carga_v2',
  ),
  MenuItemInfo(
    title: "Separação por Pedido v2",
    icon: FontAwesomeIcons.dolly,
    color: Colors.red,
    route: 'separacao_carga_v2_pedido',
  ),
  MenuItemInfo(
    title: "Conferencia NFe Saida",
    icon: FontAwesomeIcons.rightFromBracket,
    color: Colors.red,
    route: 'saidacheck',
  ),
  MenuItemInfo(
    title: "Conferencia NFe Entrada",
    icon: FontAwesomeIcons.rightToBracket,
    color: Colors.red,
    route: 'entradacheck',
  ),
  MenuItemInfo(
    title: "Reposição",
    icon: FontAwesomeIcons.boxesPacking,
    color: Colors.red,
    route: 'reposicao',
  ),
  MenuItemInfo(
    title: "Saldo por Endereço",
    icon: FontAwesomeIcons.cubes,
    color: Colors.red,
    route: 'saldo_endereco',
  ),
  MenuItemInfo(
    title: "Inventário por Endereço",
    icon: FontAwesomeIcons.clipboardCheck,
    color: Colors.red,
    route: 'inventario_endereco',
  ),
  /* MenuItemInfo(
    title: "Etiquetas Filtro",
    icon: FontAwesomeIcons.print,
    color: Colors.red,
    route: 'etiqueta_filtros/0',
  ), */
  /*  MenuItemInfo(
    title: "Etiquetas Filtro",
    icon: FontAwesomeIcons.print,
    color: Colors.red,
    route: 'etiqueta_filtros_pedidos/0',
  ), */
  MenuItemInfo(
    title: "Etiquetas Filtro",
    icon: FontAwesomeIcons.print,
    color: Colors.red,
    route: 'etiqueta_filtros_cargas',
  )
];
