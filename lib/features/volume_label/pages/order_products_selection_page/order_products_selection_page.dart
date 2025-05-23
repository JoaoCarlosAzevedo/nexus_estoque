import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/features/bluetooth_printer/bluetooth_printer.dart';
import '../../../../core/services/bt_printer.dart';
import '../../../address_inventory/pages/address_inventory_form_page/state/address_inventory_provider.dart';

import '../../data/model/volume_order_model.dart';
import '../../data/repositories/volume_label_repository.dart';
import 'provider/volume_order_provider.dart';
import 'widgets/volume_order_tab1.dart';
import 'widgets/volume_order_tab2.dart';

class VolumeOrderProductsSelectionPage extends ConsumerStatefulWidget {
  const VolumeOrderProductsSelectionPage(
      {required this.order,
      required this.numExpedicao,
      required this.orderProds,
      super.key});
  final String order;
  final String numExpedicao;
  final List<VolumeProdOrderModel> orderProds;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VolumeOrderProductsSelectionPageState();
}

class _VolumeOrderProductsSelectionPageState
    extends ConsumerState<VolumeOrderProductsSelectionPage> {
  bool isPrinted = false;
  List<VolumeProdOrderModel> products = [];

  @override
  void initState() {
    super.initState();

    //executa no final do build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(volumeOrderProvider.notifier).setInitialState(
          widget.order, widget.numExpedicao, widget.orderProds);
    });
  }

  @override
  Widget build(BuildContext context) {
    VolumeOrderState state = ref.watch(volumeOrderProvider);
    ref.listen(volumeOrderProvider, (previous, current) async {
      if (current.status == StateEnum.success) {
        ref.invalidate(volumeLabelGetOrderProvider(widget.order));
        if (state.etiqueta.isNotEmpty) {
          isPrinted = await BluetoothPrinter.printZPL(state.etiqueta);

          if (isPrinted) {
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            return;
          }
        }
      }

      if (current.status == StateEnum.error) {
        AwesomeDialog(
                // ignore: use_build_context_synchronously
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                desc: current.error,
                btnOkOnPress: () {},
                // ignore: use_build_context_synchronously
                btnOkColor: Theme.of(context).primaryColor)
            .show();
      }
      /* if (current.status == StateEnum.success) {
        // ignore: use_build_context_synchronously
        context.pop();
      } */
    });

    products = state.orderProducts;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Seleção de Produtos"),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Row(
                  children: [
                    Text("Itens Pedido"),
                    SizedBox(
                      width: 10,
                    ),
                    FaIcon(
                      FontAwesomeIcons.clipboardCheck,
                    ),
                  ],
                ),
              ),
              Tab(
                icon: Row(
                  children: [
                    Text("Embalagem"),
                    SizedBox(
                      width: 10,
                    ),
                    FaIcon(
                      FontAwesomeIcons.boxOpen,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: state.status == StateEnum.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : state.status == StateEnum.success
                  ? Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final isPrinted =
                              await BluetoothPrinter.printZPL(state.etiqueta);
                          if (!isPrinted) {
                            // ignore: use_build_context_synchronously
                            BluetoothPageModal.show(context);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("Imprimir"),
                        ),
                      ),
                    )
                  : TabBarView(
                      children: [
                        VolumeOrderTab1(orderProds: products),
                        VolumeOrderTab2(
                          etiqueta: '',
                          newVolumeProds: products,
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
