import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InputText extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool enabled;
  final void Function() onPressed;
  final void Function() onSubmitted;
  final FocusNode focus;
  final bool autoFocus;

  const InputText(
      {super.key,
      required this.controller,
      required this.label,
      required this.enabled,
      required this.onPressed,
      required this.onSubmitted,
      required this.focus,
      this.autoFocus = false});

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.enabled,
      autofocus: widget.autoFocus,
      focusNode: widget.focus,
      controller: widget.controller,
      onSubmitted: (e) {
        widget.onSubmitted();
      },
      decoration: InputDecoration(
        label: Text(widget.label),
        border: InputBorder.none,
        prefixIcon: const Icon(Icons.qr_code),
        suffixIcon: IconButton(
          onPressed: widget.onPressed,
          icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
        ),
        //icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
      ),
    );
  }
}
