import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoKeyboardTextSearchForm extends StatefulWidget {
  const NoKeyboardTextSearchForm(
      {super.key,
      this.validator,
      required this.label,
      this.onPressed,
      this.onSubmitted,
      this.onSearch,
      this.focusNode,
      this.autoFocus,
      this.onChange,
      this.prefixIcon,
      required this.controller});
  final String? Function(String?)? validator;
  final void Function()? onPressed;
  final void Function(String)? onSubmitted;
  final void Function()? onSearch;
  final String label;
  final FocusNode? focusNode;
  final TextEditingController controller;
  final bool? autoFocus;
  final bool? onChange;
  final Widget? prefixIcon;

  @override
  State<NoKeyboardTextSearchForm> createState() =>
      _NoKeyboardTextSearchFormState();
}

class _NoKeyboardTextSearchFormState extends State<NoKeyboardTextSearchForm> {
  bool showKeyboard = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        autofocus: widget.autoFocus ?? true,
        textInputAction: TextInputAction.done,
        keyboardType: showKeyboard ? TextInputType.text : TextInputType.none,
        focusNode: widget.focusNode,
        onFieldSubmitted: widget.onSubmitted,
        validator: widget.validator,
        controller: widget.controller,
        onChanged: widget.onChange ?? false
            ? !showKeyboard
                ? widget.onSubmitted
                : null
            : null,
        decoration: InputDecoration(
          label: Text(widget.label),
          border: InputBorder.none,
          prefixIcon: widget.prefixIcon ?? const Icon(Icons.qr_code),
          suffixIcon: IconButton(
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
        ),
      ),
    );
  }
}
