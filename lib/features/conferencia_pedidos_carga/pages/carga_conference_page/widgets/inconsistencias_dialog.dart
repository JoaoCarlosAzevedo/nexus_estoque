import 'package:flutter/material.dart';

import '../../../utils/conferencia_validation.dart';

class InconsistenciasDialogResult {
  const InconsistenciasDialogResult({required this.save});

  final bool save;
}

class InconsistenciasDialog extends StatelessWidget {
  const InconsistenciasDialog({
    super.key,
    required this.inconsistencias,
  });

  final List<ConferenciaInconsistencia> inconsistencias;

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<ConferenciaInconsistencia>>{};
    for (final item in inconsistencias) {
      grouped.putIfAbsent(item.pedido, () => []).add(item);
    }

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
          const SizedBox(width: 8),
          const Expanded(child: Text("Inconsistências encontradas")),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: grouped.entries.map((entry) {
              final items = entry.value;
              final cliente = items.first.cliente;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pedido ${entry.key}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      cliente,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),
                    ...items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.codProduto,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    item.descProduto,
                                    style: const TextStyle(fontSize: 12),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Pedido: ${item.quantidade}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  "Conf.: ${item.conferido}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: item.diferenca > 0
                                        ? Colors.red
                                        : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(
            const InconsistenciasDialogResult(save: false),
          ),
          child: const Text("Fechar"),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(
            const InconsistenciasDialogResult(save: true),
          ),
          child: const Text("Salvar conferência"),
        ),
      ],
    );
  }
}
