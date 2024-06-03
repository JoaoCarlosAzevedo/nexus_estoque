import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/features/filter_tags/data/model/filter_tag_load_model.dart';

import '../filter_tags_load_page/cubit/filter_tag_load_cubit.dart';

class FilterTagTab2 extends ConsumerStatefulWidget {
  const FilterTagTab2(
      {super.key, required this.invoice, required this.etiqueta});
  final Invoice invoice;
  final String etiqueta;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FilterTagTab2State();
}

class _FilterTagTab2State extends ConsumerState<FilterTagTab2> {
  @override
  Widget build(BuildContext context) {
    final products = widget.invoice.itens
        .where(
          (element) => element.novaQuantidade > 0.0,
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("NF: ${widget.invoice.notaFiscal}"),
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
              context.read<FilterTagLoadCubit>().postTag();
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
