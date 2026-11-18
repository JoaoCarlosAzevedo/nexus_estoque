import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PickingOrderSummaryCard extends StatelessWidget {
  const PickingOrderSummaryCard({
    super.key,
    required this.pedido,
    required this.rotas,
    required this.isFaturado,
    required this.isRetira,
    required this.cliente,
    required this.nfs,
    required this.qtdItens,
    this.onTap,
  });

  final String pedido;
  final String rotas;
  final bool isFaturado;
  final bool isRetira;
  final String cliente;
  final String nfs;
  final int qtdItens;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Wrap(
          children: [
            Text("Pedido $pedido"),
            if (rotas.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                "Rota $rotas",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            if (isFaturado) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'FATURADO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            const SizedBox(width: 8),
            if (isRetira)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'RETIRA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (cliente.isNotEmpty) Text(cliente),
            if (nfs.isNotEmpty) Text("NF: $nfs"),
            Text("Qtd. Itens $qtdItens"),
          ],
        ),
        trailing: const FaIcon(FontAwesomeIcons.clipboardCheck),
      ),
    );
  }
}
