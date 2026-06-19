import 'package:flutter/material.dart';

class ConfirmCargaResult {
  const ConfirmCargaResult({required this.confirmed});

  final bool confirmed;
}

class ConfirmCargaDialog extends StatelessWidget {
  const ConfirmCargaDialog({
    super.key,
    required this.carga,
  });

  final String carga;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirmar carga $carga"),
      content: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green.shade700),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Todas as quantidades conferidas estão corretas. Deseja enviar a conferência?",
                style: TextStyle(
                  color: Colors.green.shade900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          onPressed: () => Navigator.of(context).pop(
            const ConfirmCargaResult(confirmed: false),
          ),
          child: const Text("Cancelar"),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(
            const ConfirmCargaResult(confirmed: true),
          ),
          child: const Text("Confirmar e enviar"),
        ),
      ],
    );
  }
}
