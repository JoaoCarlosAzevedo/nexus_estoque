import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';

import '../../../data/model/sku_group_model.dart';

class SkuListWidget extends StatelessWidget {
  const SkuListWidget({
    super.key,
    required this.skuGroups,
    required this.onSkuTap,
    this.isCompact = false,
  });

  final List<SkuGroup> skuGroups;
  final void Function(SkuGroup sku) onSkuTap;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    if (skuGroups.isEmpty) {
      return const Center(child: Text("Nenhum item na carga."));
    }

    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: skuGroups.length,
      itemBuilder: (context, index) {
        final sku = skuGroups[index];
        return _SkuCard(
          sku: sku,
          isCompact: isCompact,
          onTap: () => onSkuTap(sku),
        );
      },
    );
  }
}

class _SkuCard extends StatelessWidget {
  const _SkuCard({
    required this.sku,
    required this.isCompact,
    required this.onTap,
  });

  final SkuGroup sku;
  final bool isCompact;
  final VoidCallback onTap;

  Color _chipColor() {
    if (sku.conferidoTotal == 0) return Colors.grey;
    if (sku.isComplete) return Colors.green;
    if (sku.isExcedente) return Colors.red;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    final chipColor = _chipColor();

    return Card(
      margin: EdgeInsets.symmetric(vertical: isCompact ? 3 : 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 12 : 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sku.codProduto,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isCompact ? 14 : 16,
                      ),
                    ),
                    if (!sku.isBlind) ...[
                      const SizedBox(height: 4),
                      Text(
                        sku.descProduto,
                        style: TextStyle(
                          fontSize: isCompact ? 12 : 13,
                          color: Colors.grey.shade700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ] else
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "Conferência cega",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: chipColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: chipColor),
                ),
                child: Text(
                  "${sku.conferidoTotal} / ${sku.quantidadeTotal}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: chipColor is MaterialColor
                        ? chipColor.shade800
                        : chipColor,
                    fontSize: isCompact ? 13 : 14,
                  ),
                ),
              ),
              IconButton(
                onPressed: onTap,
                icon: const FaIcon(
                  FontAwesomeIcons.penToSquare,
                  size: 20,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
