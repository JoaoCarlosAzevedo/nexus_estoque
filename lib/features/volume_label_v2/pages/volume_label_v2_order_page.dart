import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/features/bluetooth_printer/bluetooth_printer.dart';
import '../../../core/services/bt_printer.dart';
import '../../filter_tags_orders/data/model/filter_tag_load_order_model.dart';
import '../../filter_tags_orders/data/repositories/filter_tag_order_repository.dart';

class VolumeLabelV2OrderPage extends ConsumerWidget {
  final Orders order;

  const VolumeLabelV2OrderPage({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pedido: ${order.pedido}'),
            Text(
              order.nomeCliente,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título dos itens
              Text(
                'Etiquetas Emitidas',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),

              // Consumer para orderVolumesProvider
              Consumer(
                builder: (context, ref, child) {
                  final orderVolumesAsync =
                      ref.watch(orderVolumesProvider(order.pedido));

                  return orderVolumesAsync.when(
                    data: (orderData) {
                      if (orderData.itens.isEmpty) {
                        return const Expanded(
                          child: Center(
                            child: Text('Nenhum item encontrado'),
                          ),
                        );
                      }
                      return Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: orderData.itens.length,
                                itemBuilder: (context, index) {
                                  final item = orderData.itens[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: ExpansionTile(
                                      title: Text(
                                        item.descricao,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 4),
                                          Text('Código: ${item.codigo}'),
                                          Text('UM: ${item.um}'),
                                          const SizedBox(height: 8),
                                          if (item.codigobarras.isNotEmpty) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              'Código de Barras: ${item.codigobarras}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        ],
                                      ),
                                      children: [
                                        // Lista de volumes com ícone de impressão
                                        if (item.volumes.isNotEmpty) ...[
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Text(
                                              'Volumes:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          ...item.volumes.map((volume) =>
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 16.0,
                                                  vertical: 2.0,
                                                ),
                                                child: Card(
                                                  color: Colors.grey[50],
                                                  child: ListTile(
                                                    title: Text(
                                                        'Etiqueta ${volume.volume}/${volume.volumeMaximo}'),
                                                    trailing: IconButton(
                                                      onPressed: () {
                                                        _printVolume(
                                                            context, volume);
                                                      },
                                                      icon: const FaIcon(
                                                        FontAwesomeIcons.print,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                          const SizedBox(height: 8),
                                        ] else ...[
                                          const Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text(
                                              'Nenhum volume encontrado',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => const Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Carregando dados do pedido...'),
                          ],
                        ),
                      ),
                    ),
                    error: (error, stack) => Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.triangleExclamation,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Erro ao carregar dados',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              error.toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                ref.invalidate(
                                    orderVolumesProvider(order.pedido));
                              },
                              child: const Text('Tentar Novamente'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _printVolume(BuildContext context, OrdersProductVolume volume) async {
    final isPrinted = await BluetoothPrinter.printZPL(volume.etiqueta);
    if (!isPrinted) {
      // ignore: use_build_context_synchronously
      BluetoothPageModal.show(context);
    }
  }
}
