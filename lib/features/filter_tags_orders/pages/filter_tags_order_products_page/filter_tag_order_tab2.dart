import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/model/filter_tag_load_order_model.dart';
import '../filter_tags_order_load_page/cubit/filter_tag_order_load_cubit.dart';

class FilterTagOrderTab2 extends ConsumerStatefulWidget {
  const FilterTagOrderTab2(
      {super.key, required this.pedido, required this.etiqueta});
  final Orders pedido;
  final String etiqueta;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FilterTagOrderTab2State();
}

class _FilterTagOrderTab2State extends ConsumerState<FilterTagOrderTab2> {
  @override
  Widget build(BuildContext context) {
    final products = widget.pedido.itens
        .where(
          (element) => element.novaQuantidade > 0.0,
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Pedido: ${widget.pedido.pedido}"),
        ),
        Text("Produtos da Embalagem (${products.length.toString()})"),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    title: Text(
                        '${products[index].item} - ${products[index].codigo}'),
                    subtitle: Text(products[index].descricao),
                    trailing: Text(products[index].novaQuantidade.toString())),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              context.read<FilterTagLoadOrderCubit>().postTag();
            },
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Gerar Etiqueta"),
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: FaIcon(FontAwesomeIcons.print),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
