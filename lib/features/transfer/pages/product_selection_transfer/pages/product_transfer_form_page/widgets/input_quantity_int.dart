import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';

class InputQuantityInt extends StatefulWidget {
  const InputQuantityInt({
    super.key,
    required this.controller,
    this.onSubmitted,
  });
  final TextEditingController controller;
  final Function(String)? onSubmitted;
  @override
  State<InputQuantityInt> createState() => _InputQuantityIntState();
}

class _InputQuantityIntState extends State<InputQuantityInt> {
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
                if (double.parse(e) <= 0) {
                  /*  widget.controller.text = '0';
                  widget.controller.selection = TextSelection.collapsed(
                      offset: widget.controller.text.length); */
                }
              }
            },
          ),
        ),
        IconButton(
          iconSize: 30,
          onPressed: () {
            _setValue(1.0);
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
    }

    if (widget.controller.text.contains('0.0')) {
      widget.controller.text = "";
    } else {
      double isPositive = double.parse(widget.controller.text) + number;

      if (isPositive >= 0) {
        /* widget.controller.text =
          (double.parse(widget.controller.text) + number).toStringAsFixed(2); */
        widget.controller.text =
            (double.parse(widget.controller.text) + number).toStringAsFixed(0);
        /* widget.controller.selection =
          TextSelection.collapsed(offset: widget.controller.text.length); */
      }
    }
  }
}
