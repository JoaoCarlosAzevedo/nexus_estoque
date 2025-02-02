import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';

class InputQuantity extends StatefulWidget {
  const InputQuantity({
    super.key,
    required this.controller,
    this.focus,
    this.fator,
    this.onSubmitted,
  });
  final TextEditingController controller;
  final Function(String)? onSubmitted;
  final FocusNode? focus;
  final double? fator;
  @override
  State<InputQuantity> createState() => _InputQuantityState();
}

class _InputQuantityState extends State<InputQuantity> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          onPressed: () {
            if (widget.fator != null) {
              _setValue(-1.0 * widget.fator!);
            } else {
              _setValue(-1.0);
            }
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
            focusNode: widget.focus,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
            ],
            onSubmitted: widget.onSubmitted,
            onChanged: (e) {
              var doubleParsed = double.tryParse(e);

              if (doubleParsed != null) {
                if (double.parse(e) <= 0) {
                  widget.controller.text = '0';
                  widget.controller.selection = TextSelection.collapsed(
                      offset: widget.controller.text.length);
                }
              }
            },
          ),
        ),
        IconButton(
          iconSize: 30,
          onPressed: () {
            if (widget.fator != null) {
              _setValue(1.0 * widget.fator!);
            } else {
              _setValue(1.0);
            }
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

    double isPositive = double.parse(widget.controller.text) + number;

    if (isPositive >= 0) {
      widget.controller.text =
          (double.parse(widget.controller.text) + number).toStringAsFixed(2);

      widget.controller.selection =
          TextSelection.collapsed(offset: widget.controller.text.length);
    }
  }
}
