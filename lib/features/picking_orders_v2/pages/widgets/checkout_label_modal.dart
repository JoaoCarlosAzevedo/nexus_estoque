import 'package:flutter/material.dart';

import '../../../../core/widgets/form_input_no_keyboard_widget.dart';

class CheckoutLabelModal extends StatefulWidget {
  const CheckoutLabelModal({super.key, required this.pedido});

  final String pedido;

  static Future<String?> show(BuildContext context, String pedido) {
    return showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CheckoutLabelModal(pedido: pedido),
    );
  }

  @override
  State<CheckoutLabelModal> createState() => _CheckoutLabelModalState();
}

class _CheckoutLabelModalState extends State<CheckoutLabelModal> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _confirm() {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe a etiqueta de checkout.'),
          backgroundColor: Colors.red,
        ),
      );
      _focusNode.requestFocus();
      return;
    }
    Navigator.of(context).pop(value);
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Etiqueta de Checkout'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pedido: ${widget.pedido}'),
            const SizedBox(height: 12),
            NoKeyboardTextForm(
              controller: _controller,
              focusNode: _focusNode,
              autoFocus: true,
              label: 'Bipe ou digite a etiqueta',
              onSubmitted: (_) => _confirm(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _confirm,
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
