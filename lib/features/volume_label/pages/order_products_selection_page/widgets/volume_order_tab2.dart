import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/features/volume_label/pages/order_products_selection_page/provider/volume_order_provider.dart';

import '../../../data/model/volume_order_model.dart';

class VolumeOrderTab2 extends ConsumerStatefulWidget {
  const VolumeOrderTab2(
      {super.key, required this.newVolumeProds, required this.etiqueta});
  final List<VolumeProdOrderModel> newVolumeProds;
  final String etiqueta;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VolumeOrderTab2State();
}

class _VolumeOrderTab2State extends ConsumerState<VolumeOrderTab2> {
  @override
  Widget build(BuildContext context) {
    final products = widget.newVolumeProds
        .where(
          (element) => element.novaQtd > 0.0,
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Produtos da Embalagem (${products.length.toString()})"),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    title: Text(products[index].codigo),
                    subtitle: Text(products[index].descricao),
                    trailing: Text(products[index].novaQtd.toString())),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              //context.read<FilterTagLoadOrderCubit>().postTag();
              ref.read(volumeOrderProvider.notifier).postVolumeLabel();
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
