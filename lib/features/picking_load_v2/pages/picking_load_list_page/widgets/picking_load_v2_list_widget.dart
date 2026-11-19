import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/model/shippingv2_model.dart';
import '../../picking_load_faturamento_orders_page/picking_load_faturamento_orders_page.dart';
import '../../picking_load_streets_list_page/picking_load_v2_streets_page.dart';
import '../../picking_load_v2_order_page/picking_load_v2_order_page.dart';
import '../cubit/picking_loadv2_cubit.dart';
import 'load_v2_card_widget.dart';

class PickingLoadV2ListWidget extends ConsumerStatefulWidget {
  const PickingLoadV2ListWidget(
      {super.key,
      required this.data,
      required this.load,
      required this.dateIni,
      required this.dateEnd,
      this.openOrdersOnTap = false});
  final List<Shippingv2Model> data;
  final String load;
  final String dateIni;
  final String dateEnd;
  final bool openOrdersOnTap;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PickingLoadV2ListWidgetState();
}

class _PickingLoadV2ListWidgetState
    extends ConsumerState<PickingLoadV2ListWidget> {
  bool filterFaturado = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            /*  context.pushReplacement(
              '/etiqueta_filtros/${widget.load}',
            ); */
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
    List<Shippingv2Model> loads = widget.openOrdersOnTap
        ? List<Shippingv2Model>.from(widget.data)
        : filterFaturado
            ? widget.data.where((element) => element.isFaturado()).toList()
            : widget.data.where((element) => !element.isFaturado()).toList();

    if (widget.openOrdersOnTap && _searchQuery.isNotEmpty) {
      loads = loads.where((load) {
        return load.pedidos.any(
          (pedido) =>
              pedido.pedido.toLowerCase().contains(_searchQuery) ||
              pedido.nf.toLowerCase().contains(_searchQuery),
        );
      }).toList();
    }

    return Column(
      children: [
        if (widget.openOrdersOnTap)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar NF ou pedido...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim().toLowerCase();
                });
              },
            ),
          ),
        if (!widget.openOrdersOnTap)
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
                  setState(() {
                    filterFaturado = value;
                  });
                },
              ),
            ],
          ),
        Expanded(
          child: loads.isEmpty
              ? const Center(
                  child: Text("Nenhum registro encontrado."),
                )
              : ListView.builder(
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
                      builder: (context) => widget.openOrdersOnTap
                          ? PickingLoadFaturamentoOrdersPage(
                              cubit: cubit,
                              load: loads[index].codCarga,
                              dateIni: widget.dateIni,
                              dateEnd: widget.dateEnd,
                            )
                          : PickingLoadStreetsPagev2(
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
