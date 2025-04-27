import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/features/searches/products/data/model/product_model.dart';
import '../../../../../core/theme/app_colors.dart';

class DunQuantityModal {
  static Future<double?> show(context, ProductModel produto) async {
    {
      final result = await showModalBottomSheet<double>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return DunQuantity(
            produto: produto,
          );
        },
      );
      return result;
    }
  }
}

class DunQuantity extends StatefulWidget {
  const DunQuantity({super.key, required this.produto});
  final ProductModel produto;

  @override
  State<DunQuantity> createState() => _DunQuantityState();
}

class _DunQuantityState extends State<DunQuantity> {
  final TextEditingController controller = TextEditingController();
  double newQuantity = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(16),
          //height: MediaQuery.of(context).size.height / 2,
          child: Column(
            children: [
              Text("${widget.produto.codigo} - ${widget.produto.descricao}",
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis),
              const Divider(),
              Text("Fator: ${widget.produto.fator}",
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis),
              Text("Total: ${newQuantity.toStringAsFixed(0)}",
                  style: Theme.of(context).textTheme.displayMedium,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(
                height: 10,
              ),
              Text("Digite os volumes/caixas",
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis),
              InputQuantityDun(
                controller: controller,
                onCalc: (e) {
                  if (e > 0) {
                    setState(() {
                      newQuantity = e * widget.produto.fator;
                    });
                  }
                },
                onSubmitted: (e) {
                  final double? quantity = double.tryParse(controller.text);
                  if (quantity != null) {
                    Navigator.of(context).pop(quantity * widget.produto.fator);
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(newQuantity);
                },
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text("Confirmar"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputQuantityDun extends StatefulWidget {
  const InputQuantityDun({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.onCalc,
  });
  final TextEditingController controller;
  final Function(String)? onSubmitted;
  final Function(double)? onCalc;
  @override
  State<InputQuantityDun> createState() => _InputQuantityDunState();
}

class _InputQuantityDunState extends State<InputQuantityDun> {
  @override
  void initState() {
    _setValue(0.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          onPressed: () {
            _setValue(-1.0);
            setState(() {});
          },
          iconSize: 30,
          icon: const Icon(
            Icons.remove,
            color: AppColors.primaryRed,
          ),
        ), // decrease qty button
        Expanded(
          child: TextField(
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
            controller: widget.controller,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: false,
              signed: false,
            ),
            inputFormatters: <TextInputFormatter>[
              //FilteringTextInputFormatter.allow(RegExp(r'^\d+\d{0,0}'))
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            onSubmitted: widget.onSubmitted,
            onChanged: (e) {
              var doubleParsed = double.tryParse(e);

              if (doubleParsed != null) {
                if (widget.onCalc != null) {
                  widget.onCalc!(doubleParsed);
                }
              }
            },
          ),
        ),
        IconButton(
          iconSize: 30,
          onPressed: () {
            _setValue(1.0);
            setState(() {});
          },
          icon: const Icon(
            Icons.add,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  void _setValue(double number) {
    if (widget.controller.text.isEmpty) {
      widget.controller.text = '0';
      if (widget.onCalc != null) {
        widget.onCalc!(0.0);
      }
    }

    if (widget.controller.text.contains('0.0')) {
      widget.controller.text = "";
      if (widget.onCalc != null) {
        widget.onCalc!(0.0);
      }
    } else {
      double isPositive = double.parse(widget.controller.text) + number;

      if (isPositive >= 0) {
        widget.controller.text =
            (double.parse(widget.controller.text) + number).toStringAsFixed(0);

        if (widget.onCalc != null) {
          widget.onCalc!(double.parse(widget.controller.text));
        }
      }
    }
  }
}
