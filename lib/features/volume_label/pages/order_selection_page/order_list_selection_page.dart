import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/form_input_no_keyboard_search_widget.dart';
import '../../data/model/order_label_model.dart';
import '../../data/repositories/volume_label_repository.dart';

class OrderLabelListSelectionPage extends ConsumerStatefulWidget {
  const OrderLabelListSelectionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrderLabelListSelectionPageState();
}

class _OrderLabelListSelectionPageState
    extends ConsumerState<OrderLabelListSelectionPage> {
  @override
  Widget build(BuildContext context) {
    final list = ref.watch(orderLabelListProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Seleção de Pedido"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(orderLabelListProvider);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: list.when(
            skipLoadingOnRefresh: false,
            data: (dados) => ListOrderLabelWidget(data: dados),
            error: (err, stack) => Center(
              child: Text(err.toString()),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}

class ListOrderLabelWidget extends ConsumerStatefulWidget {
  const ListOrderLabelWidget({super.key, required this.data});
  final List<OrderLabelModel> data;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ListOrderLabelWidgetState();
}

class _ListOrderLabelWidgetState extends ConsumerState<ListOrderLabelWidget> {
  final TextEditingController controller = TextEditingController();

  List<OrderLabelModel> filterData = [];
  bool resetFilter = true;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (resetFilter) {
      filterData = widget.data;
      resetFilter = false;
    }

    return Column(
      children: [
        NoKeyboardTextSearchForm(
          label: 'Pesquisa pedido / produto',
          autoFocus: true,
          onChange: true,
          onSubmitted: (e) {
            searchOrder(e);
          },
          controller: controller,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: filterData.length,
            itemBuilder: (context, index) {
              final order = filterData[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Pedido: ${order.pedido}'),
                  subtitle: Text('Volumes: ${order.volumes}'),
                  onTap: () {
                    context.push('/etiqueta_volume_pedido/${order.pedido}');
                    controller.clear();
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void searchOrder(String value) {
    if (value.isNotEmpty) {
      setState(() {
        filterData = widget.data.where((element) {
          if (element.pedido.toUpperCase().contains(value.toUpperCase())) {
            return true;
          }

          if (element.verificarCodigoOuBarcode(value)) {
            return true;
          }
          return false;
        }).toList();
      });
    } else {
      setState(() {
        resetFilter = true;
      });
    }
  }
}
