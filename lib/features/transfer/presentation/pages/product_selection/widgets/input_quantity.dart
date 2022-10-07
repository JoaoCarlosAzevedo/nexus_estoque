import 'package:flutter/material.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';

class InputQuantity extends StatefulWidget {
  const InputQuantity({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final TextEditingController controller;
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
            _setValue(-1);
          },
          iconSize: 30,
          icon: const Icon(
            Icons.remove,
            color: AppColors.primaryRed,
          ),
        ), // decrease qty button
        Expanded(
          child: TextField(
            textAlign: TextAlign.center,
            controller: widget.controller,
            keyboardType: TextInputType.number,
            onSubmitted: (e) {},
            onChanged: (e) {
              var intParsed = int.tryParse(e);

              if (intParsed != null) {
                if (int.parse(e) <= 0) {
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
            _setValue(1);
          },
          icon: const Icon(
            Icons.add,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  void _setValue(int number) {
    int isPositive = int.parse(widget.controller.text) + number;

    if (isPositive >= 0) {
      widget.controller.text =
          (int.parse(widget.controller.text) + number).toString();
      widget.controller.selection =
          TextSelection.collapsed(offset: widget.controller.text.length);
    }
  }
}
