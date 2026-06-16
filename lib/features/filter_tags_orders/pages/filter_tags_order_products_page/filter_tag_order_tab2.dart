import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/model/filter_tag_load_order_model.dart';
import '../filter_tags_order_load_page/cubit/filter_tag_order_load_cubit.dart';

class FilterTagOrderTab2 extends ConsumerStatefulWidget {
  const FilterTagOrderTab2(
      {super.key,
      required this.pedido,
      required this.etiqueta,
      this.orderBydate});
  final Orders pedido;
  final String etiqueta;
  final String? orderBydate;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FilterTagOrderTab2State();
}

class _FilterTagOrderTab2State extends ConsumerState<FilterTagOrderTab2> {
  late final TextEditingController _volumesController;

  @override
  void initState() {
    super.initState();
    _volumesController =
        TextEditingController(text: widget.pedido.volumes.toString());
  }

  @override
  void dispose() {
    _volumesController.dispose();
    super.dispose();
  }

  void _onVolumesChanged(String value) {
    // Mantemos o objeto Orders sincronizado com o campo para que o
    // postTag (que serializa via Orders.toMap()) envie o valor digitado.
    final parsed = int.tryParse(value);
    if (parsed != null && parsed >= 0) {
      widget.pedido.volumes = parsed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gravaVolume = widget.pedido.gravaVolume;
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
        if (gravaVolume)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: [
                const Text('Volumes:'),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _volumesController,
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: false,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    onChanged: _onVolumesChanged,
                  ),
                ),
              ],
            ),
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
              context
                  .read<FilterTagLoadOrderCubit>()
                  .postTag(widget.orderBydate ?? '');
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
