import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InputSearchWidget extends StatefulWidget {
  const InputSearchWidget(
      {super.key,
      this.validator,
      required this.label,
      this.onPressed,
      this.onSubmitted,
      this.focusNode,
      this.autoFocus,
      required this.controller});
  final String? Function(String?)? validator;
  final void Function()? onPressed;
  final void Function(String)? onSubmitted;
  final String label;
  final FocusNode? focusNode;
  final TextEditingController controller;
  final bool? autoFocus;
  @override
  State<InputSearchWidget> createState() => _InputSearchWidgetState();
}

class _InputSearchWidgetState extends State<InputSearchWidget> {
  bool showKeyboard = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        autofocus: widget.autoFocus ?? true,
        textInputAction: TextInputAction.next,
        keyboardType: showKeyboard ? TextInputType.text : TextInputType.none,
        focusNode: widget.focusNode,
        onFieldSubmitted: widget.onSubmitted,
        validator: widget.validator,
        controller: widget.controller,
        decoration: InputDecoration(
          label: Text(widget.label),
          border: InputBorder.none,
          prefixIcon: IconButton(
            onPressed: () async {
              setState(() {
                showKeyboard = !showKeyboard;
                if (showKeyboard) {
                  widget.focusNode?.unfocus();
                } else {
                  Future.delayed(
                    const Duration(milliseconds: 100),
                    () =>
                        SystemChannels.textInput.invokeMethod('TextInput.hide'),
                  );
                }
              });

              Future.delayed(const Duration(milliseconds: 500), () {
                setState(() {
                  if (showKeyboard) {
                    widget.focusNode?.requestFocus();
                  }
                  // Here you can write your code for open new view
                });
              });
            },
            icon: Icon(
              Icons.keyboard,
              color: showKeyboard ? Colors.green : Colors.grey,
            ),
          ),
          suffixIcon: Focus(
            descendantsAreFocusable: false,
            canRequestFocus: false,
            child: IconButton(
              onPressed: widget.onPressed,
              icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
            ),
          ),
        ),
      ),
    );
  }
}
