import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InputText extends StatefulWidget {
  const InputText(
      {super.key,
      this.onPressed,
      required this.controller,
      required this.name});

  final VoidCallback? onPressed;
  final TextEditingController controller;
  final String name;
  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: widget.controller,
            enabled: true,
            autofocus: false,
            decoration: InputDecoration(
              label: Text(widget.name),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).secondaryHeaderColor,
          ),
          child: IconButton(
            onPressed: widget.onPressed,
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
          ),
        )
      ],
    );
  }
}
