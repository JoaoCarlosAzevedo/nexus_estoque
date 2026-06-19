import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';
import 'package:nexus_estoque/core/widgets/form_input_no_keyboard_widget.dart';
import 'package:nexus_estoque/features/conferencia_pedidos_carga/data/repositories/conferencia_pedidos_carga_repository.dart';
import 'package:nexus_estoque/features/order_check/providers/order_check_notifier_provider.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/input_quantity_int.dart';

import '../../data/model/carga_group_model.dart';
import '../../data/model/conferencia_pedido_model.dart';
import '../../providers/carga_conference_notifier_provider.dart';
import '../../providers/cargas_list_provider.dart';
import '../../utils/conferencia_validation.dart';
import 'widgets/confirm_carga_dialog.dart';
import 'widgets/inconsistencias_dialog.dart';
import 'widgets/sku_list_widget.dart';

class CargaConferencePage extends ConsumerStatefulWidget {
  const CargaConferencePage({
    super.key,
    required this.cargaGroup,
    required this.dateRange,
  });

  final CargaGroup cargaGroup;
  final String dateRange;

  @override
  ConsumerState<CargaConferencePage> createState() =>
      _CargaConferencePageState();
}

class _CargaConferencePageState extends ConsumerState<CargaConferencePage> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSaving = false;

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onCodeSubmitted(String code) {
    ref
        .read(cargaConferenceNotifierProvider(widget.cargaGroup).notifier)
        .registrarConferencia(code);
    _codeController.clear();
    _focusNode.requestFocus();
  }

  Future<void> _onEditQuantity(OrderCheckScanFeedback feedback) async {
    if (feedback.codProduto == null) return;

    final newQuantity = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _QuantityModal(
        codProduto: feedback.codProduto!,
        descProduto: feedback.isBlind ? '' : (feedback.descProduto ?? ''),
        currentQuantity: feedback.totalConferido,
      ),
    );

    if (!mounted || newQuantity == null) return;

    ref
        .read(cargaConferenceNotifierProvider(widget.cargaGroup).notifier)
        .setConferidoQuantity(feedback.codProduto!, newQuantity);

    _focusNode.requestFocus();
  }

  Future<void> _salvarConferencia(List<ConferenciaPedidoModel> pedidos) async {
    setState(() => _isSaving = true);

    final repository = ref.read(conferenciaPedidosCargaRepositoryProvider);
    final result = await repository.postConferenciaCarga(pedidos);

    if (!mounted) return;
    setState(() => _isSaving = false);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.error),
            backgroundColor: Colors.red,
          ),
        );
      },
      (_) {
        ref.invalidate(cargasListProvider(widget.dateRange));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Conferência gravada com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> _onConfirmar() async {
    final conferenceState =
        ref.read(cargaConferenceNotifierProvider(widget.cargaGroup));
    final pedidos = conferenceState.pedidos;

    final inconsistencias = findInconsistencias(pedidos);
    if (inconsistencias.isNotEmpty) {
      final result = await showDialog<InconsistenciasDialogResult>(
        context: context,
        builder: (context) => InconsistenciasDialog(
          inconsistencias: inconsistencias,
        ),
      );

      if (!mounted || result == null || !result.save) return;
      await _salvarConferencia(pedidos);
      return;
    }

    final confirmResult = await showDialog<ConfirmCargaResult>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmCargaDialog(
        carga: widget.cargaGroup.carga,
      ),
    );

    if (!mounted || confirmResult == null || !confirmResult.confirmed) return;

    await _salvarConferencia(pedidos);
  }

  @override
  Widget build(BuildContext context) {
    final conferenceState =
        ref.watch(cargaConferenceNotifierProvider(widget.cargaGroup));
    final lastFeedback = conferenceState.lastScanFeedback;
    final skuGroups = conferenceState.skuGroups;
    final isComplete = conferenceState.isConferenciaCompleta;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 360;
    final bodyPadding = isCompact ? 8.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Carga ${widget.cargaGroup.carga}"),
            Text(
              "${widget.cargaGroup.totalPedidos} pedidos",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _isSaving ? null : _onConfirmar,
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save, color: Colors.green, size: 34),
            tooltip: "Confirmar conferência",
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(bodyPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NoKeyboardTextForm(
                autoFocus: true,
                controller: _codeController,
                focusNode: _focusNode,
                label: isCompact
                    ? "Código ou barras"
                    : "Código do produto ou código de barras",
                onSubmitted: _onCodeSubmitted,
              ),
              if (lastFeedback != null) ...[
                const SizedBox(height: 8),
                _FeedbackCard(
                  feedback: lastFeedback,
                  isCompact: isCompact,
                  onEditQuantity: () => _onEditQuantity(lastFeedback),
                  onClose: () {
                    ref
                        .read(cargaConferenceNotifierProvider(widget.cargaGroup)
                            .notifier)
                        .clearFeedback();
                    _focusNode.requestFocus();
                  },
                ),
              ],
              if (isComplete) ...[
                const SizedBox(height: 8),
                Material(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade800),
                        const SizedBox(width: 8),
                        Text(
                          "Conferência completa!",
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Expanded(
                child: SkuListWidget(
                  skuGroups: skuGroups,
                  isCompact: isCompact,
                  onSkuTap: (sku) async {
                    final newQuantity = await showModalBottomSheet<int>(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => _QuantityModal(
                        codProduto: sku.codProduto,
                        descProduto: sku.isBlind ? '' : sku.descProduto,
                        currentQuantity: sku.conferidoTotal,
                      ),
                    );
                    if (!mounted || newQuantity == null) return;
                    ref
                        .read(cargaConferenceNotifierProvider(widget.cargaGroup)
                            .notifier)
                        .setConferidoQuantity(sku.codProduto, newQuantity);
                    _focusNode.requestFocus();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({
    required this.feedback,
    required this.isCompact,
    required this.onEditQuantity,
    required this.onClose,
  });

  final OrderCheckScanFeedback feedback;
  final bool isCompact;
  final VoidCallback onEditQuantity;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    if (feedback.result == OrderCheckScanResult.notFound) {
      return Card(
        color: Colors.red.shade50,
        child: ListTile(
          leading: const Icon(Icons.error_outline, color: Colors.red),
          title: const Text("Produto não encontrado"),
          subtitle: Text("Cód. Barras: ${feedback.code}"),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
          ),
        ),
      );
    }

    final totalConf = feedback.totalConferido;
    final totalQtd = feedback.totalQuantidade;
    final isOk = totalConf == totalQtd;
    final accentColor = isOk
        ? Colors.teal.shade600
        : totalConf < totalQtd
            ? Colors.amber.shade600
            : Colors.red.shade600;

    return Card(
      color: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 4, height: 60, color: accentColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feedback.isBlind
                        ? (feedback.codProduto ?? feedback.code)
                        : (feedback.descProduto ?? feedback.code),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text("SKU: ${feedback.codProduto ?? feedback.code}"),
                  const SizedBox(height: 4),
                  Text(
                    "Conferido: $totalConf / $totalQtd",
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onEditQuantity,
              icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 20),
            ),
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityModal extends StatefulWidget {
  const _QuantityModal({
    required this.codProduto,
    required this.descProduto,
    required this.currentQuantity,
  });

  final String codProduto;
  final String descProduto;
  final int currentQuantity;

  @override
  State<_QuantityModal> createState() => _QuantityModalState();
}

class _QuantityModalState extends State<_QuantityModal> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.currentQuantity}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.descProduto.isNotEmpty
                  ? "${widget.codProduto} - ${widget.descProduto}"
                  : widget.codProduto,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Divider(),
            const SizedBox(height: 16),
            InputQuantityInt(controller: _controller),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final qty = int.tryParse(_controller.text);
                if (qty != null && qty >= 0) {
                  Navigator.of(context).pop(qty);
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text("Confirmar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
