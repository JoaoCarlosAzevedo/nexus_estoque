import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/picking_user_monitor.dart';

class PickingStatusWidget extends ConsumerWidget {
  final String? separationStatus;
  final String orderNumber;
  final VoidCallback? onTap;

  const PickingStatusWidget({
    super.key,
    this.separationStatus,
    required this.orderNumber,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isInProgress = orderNumber.isNotEmpty;
    final postInitPickingState = ref.watch(postInitPickingProvider);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isInProgress ? Colors.orange.shade50 : Colors.green.shade50,
            border: Border.all(
              color:
                  isInProgress ? Colors.orange.shade300 : Colors.green.shade300,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Ícone de status
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isInProgress
                      ? Colors.orange.shade100
                      : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  isInProgress
                      ? Icons.hourglass_empty
                      : Icons.check_circle_outline,
                  color: isInProgress
                      ? Colors.orange.shade700
                      : Colors.green.shade700,
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              // Conteúdo do status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título do pedido
                    if (orderNumber.isNotEmpty)
                      Text(
                        'Pedido $orderNumber',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    const SizedBox(height: 4),

                    // Status da separação
                    Text(
                      isInProgress
                          ? 'Em processo de separação'
                          : 'Disponível para nova separação',
                      style: TextStyle(
                        fontSize: 14,
                        color: isInProgress
                            ? Colors.orange.shade800
                            : Colors.green.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    /* // Detalhes adicionais se estiver em processo
                    if (isInProgress && separationStatus != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Separador: $separationStatus',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade800,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ), */
                  ],
                ),
              ),

              // Botão de pause/encerrar quando estiver em progresso
              if (isInProgress)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: postInitPickingState.when(
                    loading: () => Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.orange),
                          ),
                        ),
                      ),
                    ),
                    error: (error, stackTrace) => IconButton(
                      onPressed: () async {
                        await ref
                            .read(postInitPickingProvider.notifier)
                            .postEndPicking(
                                orderNumber, 'Fim Manual Separacao');
                        ref.invalidate(fetchUserMonitorProvider);
                      },
                      icon: Icon(
                        Icons.pause_circle_outline,
                        color: Colors.red.shade700,
                        size: 24,
                      ),
                      tooltip: 'Pausar/Encerrar',
                    ),
                    data: (data) => IconButton(
                      onPressed: () async {
                        await ref
                            .read(postInitPickingProvider.notifier)
                            .postEndPicking(
                                orderNumber, 'Fim Manual Separacao');
                        ref.invalidate(fetchUserMonitorProvider);
                      },
                      icon: Icon(
                        Icons.pause_circle_outline,
                        color: Colors.orange.shade700,
                        size: 24,
                      ),
                      tooltip: 'Pausar/Encerrar',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
