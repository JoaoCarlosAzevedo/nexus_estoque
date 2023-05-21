import 'package:flutter/material.dart';
import 'package:nexus_estoque/features/reposition/data/model/reposition_model.dart';

class RepositionCard extends StatelessWidget {
  const RepositionCard({super.key, required this.reposition});
  final RepositionModel reposition;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${reposition.codProduto} - ${reposition.descProduto}'),
            const Divider(),
            Text(
                '${reposition.descEndereco} ---> ${reposition.descEnderecoRetira}'),
            Text('${reposition.quant} ---> ${reposition.quantAbastecer}'),
          ],
        ),
      ),
    );
  }
}
