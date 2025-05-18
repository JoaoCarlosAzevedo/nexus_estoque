import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_estoque/core/mixins/validation_mixin.dart';

import '../../data/model/pickingv2_model.dart';

class SerialListModal {
  static Future<double> show(
      context, Pickingv2Model picking, List<String> seriais) async {
    {
      final result = await showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.8,
            child: ListSerial(
              picking: picking,
              seriais: seriais,
            ),
          );
        },
      );
      if (result != null) {
        return result;
      } else {
        return 0.0;
      }
    }
  }
}

class ListSerial extends ConsumerStatefulWidget {
  const ListSerial({super.key, required this.picking, required this.seriais});
  final Pickingv2Model picking;
  final List<String> seriais;

  @override
  ConsumerState<ListSerial> createState() => _ListSerialState();
}

class _ListSerialState extends ConsumerState<ListSerial> with ValidationMixi {
  List<String> seriais = [];

  bool checkProduct = false;
  double quantity = 0;
  bool isMultiple = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Num. de Séries Coletados"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Pedido/Item: ${widget.picking.pedido}/${widget.picking.itemPedido}"),
            Text("Produto: ${widget.picking.descricao}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "Par: ${widget.picking.qtdPar}",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Text(
                    "Kit: ${widget.picking.qtdKit}",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Qtd Cód. Série: ${widget.seriais.length} / ${widget.picking.qtdSerial}",
                style: TextStyle(
                    color: widget.seriais.length > widget.picking.qtdSerial
                        ? Colors.red
                        : widget.seriais.length < widget.picking.qtdSerial
                            ? Colors.orange
                            : Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.seriais.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(widget.seriais[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            widget.seriais.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final numSeriais = widget.seriais.length;
                context.pop(numSeriais.toDouble());
              },
              child: const SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Center(child: Text("Confirmar")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showValidation(context, String message) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            desc: message,
            btnOkOnPress: () {},
            btnOkColor: Theme.of(context).primaryColor)
        .show();
  }
}
