import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Distributors { dellas, decminas, portolub, todos, brazmax, audiogene }

//const buildDistribuitor = Distributors.decminas;
//const buildDistribuitor = Distributors.brazmax;
//const buildDistribuitor = Distributors.decminas;
const buildDistribuitor = Distributors.dellas;

bool checkMenu(Distributors dist, Distributors check) {
  if (dist == Distributors.todos) {
    return true;
  }

  if (dist == check) {
    return true;
  }

  return false;
}

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
/* 
final List<MenuItemInfo> menuItens = [
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
  ...checkMenu(buildDistribuitor, Distributors.portolub)
      ? [
          MenuItemInfo(
            title: "Movimentos Internos",
            icon: FontAwesomeIcons.boxesPacking,
            color: Colors.red,
            route: 'movimentos',
          ),
        ]
      : [],
  ...checkMenu(buildDistribuitor, Distributors.decminas)
      ? [
          MenuItemInfo(
            title: "Separação por Pedido",
            icon: FontAwesomeIcons.dolly,
            color: Colors.red,
            route: 'separacao',
          )
        ]
      : [],
  /* ...checkMenu(buildDistribuitor, Distributors.decminas)
      ? [
          MenuItemInfo(
            title: "Separação por Rotas",
            icon: FontAwesomeIcons.truckRampBox,
            color: Colors.red,
            route: 'separacao_rotas',
          )
        ]
      : [], */
  ...checkMenu(buildDistribuitor, Distributors.decminas)
      ? [
          MenuItemInfo(
            title: "Separação por Carga",
            icon: FontAwesomeIcons.truckArrowRight,
            color: Colors.red,
            route: 'separacao_carga',
          )
        ]
      : [],
  ...checkMenu(buildDistribuitor, Distributors.dellas)
      ? [
          MenuItemInfo(
            title: "Separação por Carga v2",
            icon: FontAwesomeIcons.truckArrowRight,
            color: Colors.red,
            route: 'separacao_carga_v2',
          ),
        ]
      : [],
  ...checkMenu(buildDistribuitor, Distributors.dellas)
      ? [
          MenuItemInfo(
            title: "Separação por Pedido v2",
            icon: FontAwesomeIcons.dolly,
            color: Colors.red,
            route: 'separacao_carga_v2_pedido',
          ),
        ]
      : [],
  MenuItemInfo(
    title: "Conferencia NFe Saida",
    icon: FontAwesomeIcons.rightFromBracket,
    color: Colors.red,
    route: 'saidacheck',
  ),
  MenuItemInfo(
    title: "Separacao Pedidos Sem Carga",
    icon: FontAwesomeIcons.dolly,
    color: Colors.red,
    route: 'separaca_pedidos_v2',
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
    title: "Consulta Produto",
    icon: FontAwesomeIcons.box,
    color: Colors.red,
    route: 'detalhe_produto_listagem',
  ),
  MenuItemInfo(
    title: "Inventário por Endereço",
    icon: FontAwesomeIcons.clipboardCheck,
    color: Colors.red,
    route: 'inventario_endereco',
  ),
  MenuItemInfo(
    title: "Etiqueta Produto",
    icon: FontAwesomeIcons.tag,
    color: Colors.red,
    route: 'etiqueta_produto_listagem',
  ),
  MenuItemInfo(
    title: "Etiqueta Endereços",
    icon: FontAwesomeIcons.tags,
    color: Colors.red,
    route: 'etiqueta_enderecos_listagem',
  ),
  ...checkMenu(buildDistribuitor, Distributors.brazmax)
      ? [
          MenuItemInfo(
            title: "Inventário",
            icon: FontAwesomeIcons.clipboardCheck,
            color: Colors.red,
            route: 'inventario',
          ),
        ]
      : [],
  ...checkMenu(buildDistribuitor, Distributors.dellas)
      ? [
          MenuItemInfo(
            title: "Etiquetas Filtro",
            icon: FontAwesomeIcons.print,
            color: Colors.red,
            route: 'etiqueta_filtros_cargas',
          )
        ]
      : [],
];  */

//menu audiogente
/* 
final List<MenuItemInfo> menuItens = [
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
    title: "Separacao Pedidos Sem Carga",
    icon: FontAwesomeIcons.dolly,
    color: Colors.red,
    route: 'separaca_pedidos_v2',
  ),
  MenuItemInfo(
    title: "Reposição",
    icon: FontAwesomeIcons.boxesPacking,
    color: Colors.red,
    route: 'reposicao_v2',
    //route: 'reposicao',
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
  MenuItemInfo(
    title: "Etiqueta Produto",
    icon: FontAwesomeIcons.tag,
    color: Colors.red,
    route: 'etiqueta_produto_listagem',
  ),
  MenuItemInfo(
    title: "Etiqueta Endereços",
    icon: FontAwesomeIcons.tags,
    color: Colors.red,
    route: 'etiqueta_enderecos_listagem',
  ),
  MenuItemInfo(
    title: "Import. NF",
    icon: FontAwesomeIcons.receipt,
    color: Colors.red,
    route: 'importar_nf_entrada',
  ),
  MenuItemInfo(
    title: "Etiquetas Volume",
    icon: FontAwesomeIcons.cubes,
    color: Colors.red,
    route: 'etiqueta_volume',
  ),
  MenuItemInfo(
    title: "Consulta Produto",
    icon: FontAwesomeIcons.box, 
    color: Colors.red,
    route: 'detalhe_produto_listagem',
  ),
];
 */

final List<MenuItemInfo> menuItens = [
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
  MenuItemInfo(
    title: "Movimentos Internos",
    icon: FontAwesomeIcons.boxesPacking,
    color: Colors.red,
    route: 'movimentos',
  ),
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
  ),
  MenuItemInfo(
    title: "Separação por Carga v2",
    icon: FontAwesomeIcons.truckArrowRight,
    color: Colors.red,
    route: 'separacao_carga_v2',
  ),
  MenuItemInfo(
    title: "Separação por Pedido",
    icon: FontAwesomeIcons.dolly,
    color: Colors.red,
    route: 'separacao',
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
    title: "Separacao Pedidos Sem Carga",
    icon: FontAwesomeIcons.dolly,
    color: Colors.red,
    route: 'separaca_pedidos_v2',
  ),
  MenuItemInfo(
    title: "Reposição",
    icon: FontAwesomeIcons.boxesPacking,
    color: Colors.red,
    route: 'reposicao',
  ),
  MenuItemInfo(
    title: "Reposição v2",
    icon: FontAwesomeIcons.boxesPacking,
    color: Colors.red,
    route: 'reposicao_v2',
  ),
  MenuItemInfo(
    title: "Saldo por Endereço",
    icon: FontAwesomeIcons.cubes,
    color: Colors.red,
    route: 'saldo_endereco',
  ),
  MenuItemInfo(
    title: "Consulta Produto",
    icon: FontAwesomeIcons.box,
    color: Colors.red,
    route: 'detalhe_produto_listagem',
  ),
  MenuItemInfo(
    title: "Inventário por Endereço",
    icon: FontAwesomeIcons.clipboardCheck,
    color: Colors.red,
    route: 'inventario_endereco',
  ),
  MenuItemInfo(
    title: "Etiqueta Produto",
    icon: FontAwesomeIcons.tag,
    color: Colors.red,
    route: 'etiqueta_produto_listagem',
  ),
  MenuItemInfo(
    title: "Etiqueta Endereços",
    icon: FontAwesomeIcons.tags,
    color: Colors.red,
    route: 'etiqueta_enderecos_listagem',
  ),
  MenuItemInfo(
    title: "Etiquetas Filtro",
    icon: FontAwesomeIcons.print,
    color: Colors.red,
    route: 'etiqueta_filtros_cargas',
  ),
  MenuItemInfo(
    title: "Inventário",
    icon: FontAwesomeIcons.clipboardCheck,
    color: Colors.red,
    route: 'inventario',
  ),
  MenuItemInfo(
    title: "Consulta Produto",
    icon: FontAwesomeIcons.box,
    color: Colors.red,
    route: 'detalhe_produto_listagem',
  ),
  MenuItemInfo(
    title: "Import. NF",
    icon: FontAwesomeIcons.receipt,
    color: Colors.red,
    route: 'importar_nf_entrada',
  ),
  MenuItemInfo(
    title: "Etiquetas Volume",
    icon: FontAwesomeIcons.cubes,
    color: Colors.red,
    route: 'etiqueta_volume',
  ),
];





/*   MenuItemInfo(
    title: "Movimentos Internos",
    icon: FontAwesomeIcons.boxesPacking,
    color: Colors.red,
    route: 'movimentos',
  ),
  
   */
