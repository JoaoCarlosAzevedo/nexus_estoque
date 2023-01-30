import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InputSearchWidget extends StatefulWidget {
  const InputSearchWidget(
      {super.key, this.validator, required this.label, this.onPressed});
  final String? Function(String?)? validator;
  final void Function()? onPressed;
  final String label;
  @override
  State<InputSearchWidget> createState() => _InputSearchWidgetState();
}

class _InputSearchWidgetState extends State<InputSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        validator: widget.validator,
        decoration: InputDecoration(
          label: Text(widget.label),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.qr_code),
          suffixIcon: IconButton(
            onPressed: widget.onPressed,
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
          ),
        ),
      ),
    );
  }
}
