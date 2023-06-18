import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nexus_estoque/core/mixins/validation_mixin.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';

class DateTextField extends StatelessWidget with ValidationMixi {
  const DateTextField({super.key, required this.controller, this.validator});
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [DateTextFormatter()],
        validator: validator,
        decoration: InputDecoration(
          label: const Text("Venc. Lote"),
          suffixIcon: IconButton(
            onPressed: () async {
              String? result = await showDateTimePicker(context: context);
              if (result != null) {
                controller.text = result;
              }
            },
            icon: const Icon(Icons.date_range),
          ),
        ),
      ),
    );
  }

  Future<String?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.grey,
              onPrimary: AppColors.background,
              onSurface: AppColors.grey,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null) return null;

    //if (!context.mounted) return selectedDate;

    return formatter.format(selectedDate);
  }
}

class DateTextFormatter extends TextInputFormatter {
  static const _maxChars = 8;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String separator = '/';
    var text = _format(
      newValue.text,
      oldValue.text,
      separator,
    );

    return newValue.copyWith(
      text: text,
      selection: updateCursorPosition(
        oldValue,
        text,
      ),
    );
  }

  String _format(
    String value,
    String oldValue,
    String separator,
  ) {
    var isErasing = value.length < oldValue.length;
    var isComplete = value.length > _maxChars + 2;

    if (!isErasing && isComplete) {
      return oldValue;
    }

    value = value.replaceAll(separator, '');
    final result = <String>[];

    for (int i = 0; i < min(value.length, _maxChars); i++) {
      result.add(value[i]);
      if ((i == 1 || i == 3) && i != value.length - 1) {
        result.add(separator);
      }
    }

    return result.join();
  }

  TextSelection updateCursorPosition(
    TextEditingValue oldValue,
    String text,
  ) {
    var endOffset = max(
      oldValue.text.length - oldValue.selection.end,
      0,
    );

    var selectionEnd = text.length - endOffset;

    return TextSelection.fromPosition(TextPosition(offset: selectionEnd));
  }
}
