import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../../core/features/bluetooth_printer/bluetooth_printer.dart';
import '../../../../core/services/bt_printer.dart';
import '../../data/model/volume_order_model.dart';
import '../../data/repositories/volume_label_repository.dart';
import '../order_products_selection_page/order_products_selection_page.dart';

class VolumeOrderDetailPage extends ConsumerStatefulWidget {
  const VolumeOrderDetailPage({required this.order, super.key});
  final String order;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VolumeOrderDetailPageState();
}

class _VolumeOrderDetailPageState extends ConsumerState<VolumeOrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    final futureProvider = ref.watch(volumeLabelGetOrderProvider(widget.order));
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Pedido ${widget.order}"),
        ),
        body: futureProvider.when(
          skipLoadingOnRefresh: false,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) {
            return Center(child: Text(err.toString()));
          },
          data: (data) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: AppBar(
                      bottom: TabBar(
                        tabs: [
                          const Tab(
                            icon: Icon(Icons.content_paste_go),
                          ),
                          Tab(
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.print,
                                ),
                                Text("(${data.etiquetas.length})"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        GroupedListView<VolumeProdOrderModel, String>(
                          elements: data.produtos,
                          groupBy: (element) =>
                              "${element.pedido}|${element.numExp}",
                          groupSeparatorBuilder: (String groupByValue) {
                            final param = groupByValue.split('|');
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "Pedido ${param[0]} - Expedição ${param[1]}",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      IconButton.filledTonal(
                                        iconSize: 30,
                                        color: Colors.green,
                                        onPressed: () {
                                          final products = data.produtos
                                              .where((element) =>
                                                  element.numExp == param[1])
                                              .toList();

                                          final grouped =
                                              agruparVolumes(products);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  VolumeOrderProductsSelectionPage(
                                                order: param[0],
                                                numExpedicao: param[1],
                                                orderProds: grouped,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const FaIcon(
                                          FontAwesomeIcons.squarePlus,
                                          color: Colors.green,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          itemBuilder: (context, VolumeProdOrderModel element) {
                            return Container();
                          },
                          //useStickyGroupSeparators: true, // optional
                          floatingHeader: true, // optional
                          order: GroupedListOrder.ASC, // optional
                        ),
                        ListView.builder(
                          itemCount: data.etiquetas.length,
                          itemBuilder: (context, index) {
                            final element = data.etiquetas[index];
                            return Card(
                              child: ListTile(
                                onTap: () {},
                                title: Text('Volume: ${element.volume}'),
                                subtitle:
                                    Text('Nº Expedição: ${element.numExp}'),
                                trailing: IconButton.filledTonal(
                                  iconSize: 30,
                                  color: Colors.green,
                                  onPressed: () async {
                                    final isPrinted =
                                        await BluetoothPrinter.printZPL(
                                            element.zpl);
                                    if (!isPrinted) {
                                      // ignore: use_build_context_synchronously
                                      BluetoothPageModal.show(context);
                                    }
                                  },
                                  icon: const FaIcon(
                                    FontAwesomeIcons.print,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
