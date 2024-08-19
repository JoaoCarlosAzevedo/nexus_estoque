import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_estoque/features/picking_load_v2/pages/picking_load_v2_order_page/picking_load_v2_order_page.dart';

import '../../../picking_load_v2/data/model/shippingv2_model.dart';
import '../../../picking_load_v2/pages/picking_load_list_page/cubit/picking_loadv2_cubit.dart';
import '../../../picking_load_v2/pages/picking_load_list_page/widgets/load_v2_card_widget.dart';
import '../../picking_load_orders/picking_load_orders_page.dart';

class PickingLoadList extends ConsumerStatefulWidget {
  const PickingLoadList(
      {super.key,
      required this.data,
      required this.load,
      required this.dateIni,
      required this.dateEnd});
  final List<Shippingv2Model> data;
  final String load;
  final String dateIni;
  final String dateEnd;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PickingLoadListState();
}

class _PickingLoadListState extends ConsumerState<PickingLoadList> {
  bool filterFaturado = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.load.isNotEmpty) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title: 'Carga: ${widget.load}',
          desc: 'Deseja gerar etiqueta?',
          btnCancelOnPress: () {
            context.pop();
          },
          btnOkOnPress: () {
            context.pushReplacement(
              '/etiqueta_filtros_pedidos/${widget.load}',
            );
          },
        ).show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Shippingv2Model> loads = [];

    if (filterFaturado) {
      loads = widget.data.where((element) => element.isFaturado()).toList();
    } else {
      //data = state.loads;
      loads = widget.data.where((element) => !element.isFaturado()).toList();
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Filtra Faturados? ${widget.load}"),
            const SizedBox(
              width: 15,
            ),
            Switch(
              value: filterFaturado,
              activeColor: Colors.green,
              inactiveTrackColor: Colors.grey,
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {
                  filterFaturado = value;
                });
              },
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: loads.length,
            itemBuilder: (context, index) {
              return Loadv2CardWidget(
                load: loads[index],
                onSearch: () {
                  final cubit = context.read<PickingLoadv2Cubit>();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PickingLoadv2OrderStatusPage(
                        cubit: cubit,
                        load: loads[index].codCarga,
                        dateIni: widget.dateIni,
                        dateEnd: widget.dateEnd,
                      ),
                    ),
                  );
                },
                onTap: () {
                  final cubit = context.read<PickingLoadv2Cubit>();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PickingLoadOrdersPage(
                        cubit: cubit,
                        load: loads[index].codCarga,
                        dateIni: widget.dateIni,
                        dateEnd: widget.dateEnd,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
