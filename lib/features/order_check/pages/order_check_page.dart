import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';
import 'package:nexus_estoque/core/widgets/form_input_no_keyboard_widget.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/input_quantity_int.dart';

import '../data/model/order_check_model.dart';
import '../data/repositories/order_check_repository.dart';
import '../providers/order_check_notifier_provider.dart';
import '../providers/order_check_provider.dart';

bool _isConferenciaCompletaPorSku(List<OrderCheckItemModel> itens) {
  if (itens.isEmpty) return false;
  final qtdPorSku = <String, int>{};
  final confPorSku = <String, int>{};
  for (final item in itens) {
    final cod = item.codProduto.trim();
    qtdPorSku[cod] = (qtdPorSku[cod] ?? 0) + item.quantidade;
    confPorSku[cod] = (confPorSku[cod] ?? 0) + item.conferido;
  }
  return qtdPorSku.keys.every((cod) => confPorSku[cod] == qtdPorSku[cod]);
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.shade200),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color.shade700,
        ),
      ),
    );
  }
}

class OrderCheckPage extends ConsumerStatefulWidget {
  const OrderCheckPage({
    super.key,
    required this.pedido,
  });

  final OrderCheckModel pedido;

  @override
  ConsumerState<OrderCheckPage> createState() => _OrderCheckPageState();
}

class _OrderCheckPageState extends ConsumerState<OrderCheckPage> {
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
        .read(orderCheckNotifierProvider(widget.pedido).notifier)
        .registrarConferencia(code);
    _codeController.clear();
    _focusNode.requestFocus();
  }

  Future<void> _onEditQuantity(
    OrderCheckScanFeedback feedback,
    List<OrderCheckItemModel> itens,
    FocusNode focusNode,
  ) async {
    if (feedback.codProduto == null) return;

    final itensComSku =
        itens.where((i) => i.codProduto.trim() == feedback.codProduto!.trim());
    final totalConf = itensComSku.fold<int>(0, (sum, i) => sum + i.conferido);

    final newQuantity = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _OrderCheckQuantityModal(
        codProduto: feedback.codProduto!,
        descProduto: feedback.isBlind ? '' : (feedback.descProduto ?? ''),
        currentQuantity: totalConf,
      ),
    );

    if (!mounted || newQuantity == null) return;

    ref
        .read(orderCheckNotifierProvider(widget.pedido).notifier)
        .setConferidoQuantity(feedback.codProduto!, newQuantity);

    focusNode.requestFocus();
  }

  Future<void> _onSaveConferencia() async {
    final itens = ref.read(orderCheckNotifierProvider(widget.pedido)).itens;
    if (itens.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ConfirmacaoConferenciaDialog(
        pedido: widget.pedido,
        itens: itens,
      ),
    );

    if (!mounted || confirmed != true) return;

    setState(() => _isSaving = true);

    final repository = ref.read(orderCheckRepositoryProvider);
    final result = await repository.postConferencia(itens);

    if (!mounted) return;
    setState(() => _isSaving = false);

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure.error),
          backgroundColor: Colors.red,
        ),
      ),
      (_) {
        ref.invalidate(orderCheckProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Conferência gravada com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderCheckState =
        ref.watch(orderCheckNotifierProvider(widget.pedido));
    final pedido = widget.pedido;
    final itens = orderCheckState.itens;
    final isConferenciaCompleta = _isConferenciaCompletaPorSku(itens);
    final lastFeedback = orderCheckState.lastScanFeedback;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 360;
    final horizontalPadding = isCompact ? 8.0 : 12.0;
    final bodyPadding = isCompact ? 8.0 : 16.0;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: isCompact ? 8 : null,
          title: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Pedido ${pedido.pedido}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: isCompact ? 14 : 20,
                    ),
                  ),
                  Text(
                    pedido.cliente,
                    style: TextStyle(
                      fontSize: isCompact ? 11 : 12,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: _isSaving ? null : _onSaveConferencia,
              icon: _isSaving
                  ? SizedBox(
                      width: isCompact ? 18 : 20,
                      height: isCompact ? 18 : 20,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.save,
                      size: isCompact ? 24 : 26, color: Colors.green),
              tooltip: "Gravar conferência",
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Conferência"),
                    SizedBox(width: 10),
                    FaIcon(FontAwesomeIcons.boxOpen),
                  ],
                ),
              ),
              Tab(
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Pendentes"),
                    SizedBox(width: 10),
                    FaIcon(FontAwesomeIcons.clipboardCheck),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 16,
                  left: bodyPadding,
                  right: bodyPadding,
                  bottom: bodyPadding,
                ),
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
                      _OrderCheckFeedbackCard(
                        feedback: lastFeedback,
                        itens: itens,
                        horizontalPadding: horizontalPadding,
                        isCompact: isCompact,
                        onEditQuantity: () => _onEditQuantity(
                          lastFeedback,
                          itens,
                          _focusNode,
                        ),
                        onClose: () {
                          ref
                              .read(orderCheckNotifierProvider(widget.pedido)
                                  .notifier)
                              .clearFeedback();
                          _focusNode.requestFocus();
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (isConferenciaCompleta) ...[
                      Material(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: EdgeInsets.all(isCompact ? 8.0 : 12.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: isCompact ? 20 : 24,
                              ),
                              SizedBox(width: isCompact ? 6 : 8),
                              Flexible(
                                child: Text(
                                  "Conferência completa!",
                                  style: TextStyle(
                                    color: Colors.green.shade800,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isCompact ? 13 : 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Expanded(
                      child: ListView.builder(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        itemCount: itens.length,
                        itemBuilder: (context, index) {
                          final item = itens[index];
                          return _OrderCheckItemCard(
                            item: item,
                            isCompact: isCompact,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 16,
                  left: bodyPadding,
                  right: bodyPadding,
                  bottom: bodyPadding,
                ),
                child: _ConferidosTab(itens: itens, isCompact: isCompact),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderCheckFeedbackCard extends StatelessWidget {
  const _OrderCheckFeedbackCard({
    required this.feedback,
    required this.itens,
    required this.horizontalPadding,
    required this.isCompact,
    required this.onEditQuantity,
    required this.onClose,
  });

  final OrderCheckScanFeedback feedback;
  final List<OrderCheckItemModel> itens;
  final double horizontalPadding;
  final bool isCompact;
  final VoidCallback onEditQuantity;
  final VoidCallback onClose;

  int _getTotalConferido() {
    if (feedback.codProduto == null) return feedback.totalConferido;
    final itensComSku =
        itens.where((i) => i.codProduto.trim() == feedback.codProduto!.trim());
    return itensComSku.fold<int>(0, (sum, i) => sum + i.conferido);
  }

  int _getTotalQuantidade() {
    if (feedback.codProduto == null) return feedback.totalQuantidade;
    final itensComSku =
        itens.where((i) => i.codProduto.trim() == feedback.codProduto!.trim());
    return itensComSku.fold<int>(0, (sum, i) => sum + i.quantidade);
  }

  @override
  Widget build(BuildContext context) {
    switch (feedback.result) {
      case OrderCheckScanResult.success:
        return _buildProductScannedCard(context);
      case OrderCheckScanResult.notFound:
        return _buildErrorCard(
          context,
          "Produto não encontrado",
          "Cód. Barras: ${feedback.code}",
          Colors.red,
          Icons.error_outline,
        );
    }
  }

  Widget _buildProductScannedCard(BuildContext context) {
    final totalConf = _getTotalConferido();
    final totalQtd = _getTotalQuantidade();
    final isAbaixo = totalConf < totalQtd;
    final isAcima = totalConf > totalQtd;
    final isOk = !isAbaixo && !isAcima;
    final accentColor = isOk
        ? Colors.teal.shade600
        : isAbaixo
            ? Colors.amber.shade600
            : Colors.red.shade600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            color: AppColors.background,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 4,
                    color: accentColor,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Produto conferido",
                            style: TextStyle(
                              fontSize: isCompact ? 11 : 12,
                              fontWeight: FontWeight.w600,
                              color: accentColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            feedback.isBlind
                                ? (feedback.codProduto ?? feedback.code)
                                : (feedback.descProduto ?? feedback.code),
                            style: TextStyle(
                              color: AppColors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: isCompact ? 14 : 15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "SKU: ${feedback.codProduto ?? feedback.code}",
                            style: const TextStyle(
                              color: AppColors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (isAbaixo)
                                const _StatusChip(
                                  label: "Pendente",
                                  color: Colors.amber,
                                ),
                              if (isOk)
                                const _StatusChip(
                                  label: "OK",
                                  color: Colors.teal,
                                ),
                              if (isAcima)
                                const _StatusChip(
                                  label: "Excedente",
                                  color: Colors.red,
                                ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: accentColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "Conferido: $totalConf",
                                  style: TextStyle(
                                    color: accentColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: onEditQuantity,
                                icon: const FaIcon(
                                  FontAwesomeIcons.penToSquare,
                                  size: 24,
                                  color: AppColors.grey,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -4,
            right: -4,
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Icon(Icons.close, color: Colors.grey.shade700, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    IconData icon,
  ) {
    final isError = color == Colors.red;
    final accentColor = isError ? Colors.red.shade600 : Colors.amber.shade600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            color: AppColors.background,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 4,
                    color: accentColor,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            icon,
                            color: accentColor,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Produto conferido",
                                  style: TextStyle(
                                    fontSize: isCompact ? 11 : 12,
                                    fontWeight: FontWeight.w600,
                                    color: accentColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  title,
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: isCompact ? 14 : 15,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -4,
            right: -4,
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.grey.shade700,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCheckQuantityModal extends StatefulWidget {
  const _OrderCheckQuantityModal({
    required this.codProduto,
    required this.descProduto,
    required this.currentQuantity,
  });

  final String codProduto;
  final String descProduto;
  final int currentQuantity;

  @override
  State<_OrderCheckQuantityModal> createState() =>
      _OrderCheckQuantityModalState();
}

class _OrderCheckQuantityModalState extends State<_OrderCheckQuantityModal> {
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

class _OrderCheckItemCard extends StatelessWidget {
  const _OrderCheckItemCard({
    required this.item,
    this.isCompact = false,
  });

  final OrderCheckItemModel item;
  final bool isCompact;

  Color _getConferidoChipColor() {
    if (item.conferido == 0) return Colors.grey;
    if (item.conferido < item.quantidade) return Colors.orange;
    if (item.conferido == item.quantidade) return Colors.green;
    return Colors.red; // exceder
  }

  @override
  Widget build(BuildContext context) {
    final chipFontSize = isCompact ? 11.0 : 12.0;
    final padding = isCompact ? 12.0 : 16.0;

    return Card(
      margin: EdgeInsets.symmetric(vertical: isCompact ? 3.0 : 4.0),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: padding, vertical: isCompact ? 6 : 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.isBlind
                  ? "${item.item}-${item.codProduto}"
                  : "${item.item}-${item.descProduto}",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isCompact ? 13 : 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: isCompact ? 4 : 6),
            Text(
              "Cód: ${item.codProduto}",
              style: TextStyle(
                fontSize: isCompact ? 12 : 13,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: isCompact ? 4 : 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildStatusChip(
                  "Conf: ${item.conferido}",
                  _getConferidoChipColor(),
                  chipFontSize,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color, double fontSize) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 8,
        vertical: isCompact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _ConferidosTab extends StatelessWidget {
  const _ConferidosTab({
    required this.itens,
    this.isCompact = false,
  });

  final List<OrderCheckItemModel> itens;
  final bool isCompact;

  List<_SkuConferido> _agruparPorSku(List<OrderCheckItemModel> itensPedido) {
    final map = <String, _SkuConferido>{};
    for (final item in itensPedido) {
      if (map.containsKey(item.codProduto)) {
        final existente = map[item.codProduto]!;
        map[item.codProduto] = _SkuConferido(
          codProduto: item.codProduto,
          descProduto: existente.descProduto,
          totalQuantidade: existente.totalQuantidade + item.quantidade,
          totalConferido: existente.totalConferido + item.conferido,
          isBlind: existente.isBlind || item.isBlind,
        );
      } else {
        map[item.codProduto] = _SkuConferido(
          codProduto: item.codProduto,
          descProduto: item.descProduto,
          totalQuantidade: item.quantidade,
          totalConferido: item.conferido,
          isBlind: item.isBlind,
        );
      }
    }
    return map.values.toList();
  }

  Widget _buildLegendaChip(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color),
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: isCompact ? 11 : 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final todosSkus = _agruparPorSku(itens);
    final skusPendentes =
        todosSkus.where((s) => s.totalConferido != s.totalQuantidade).toList();
    final totalGeral = itens.fold<int>(0, (sum, item) => sum + item.conferido);
    final padding = isCompact ? 8.0 : 12.0;

    if (todosSkus.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: isCompact ? 48 : 64,
                color: Colors.grey[400],
              ),
              SizedBox(height: isCompact ? 12 : 16),
              Text(
                "Nenhum produto no pedido",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isCompact ? 14 : 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (skusPendentes.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.all(padding),
            child: Material(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: EdgeInsets.all(isCompact ? 12.0 : 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total conferido",
                      style: TextStyle(
                        fontSize: isCompact ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      "$totalGeral itens",
                      style: TextStyle(
                        fontSize: isCompact ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: isCompact ? 48 : 64,
                      color: Colors.green,
                    ),
                    SizedBox(height: isCompact ? 12 : 16),
                    Text(
                      "Todos os produtos conferidos!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isCompact ? 14 : 16,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 4),
          child: Row(
            children: [
              _buildLegendaChip(Colors.orange, "Abaixo do pedido"),
              const SizedBox(width: 12),
              _buildLegendaChip(Colors.red, "Acima do pedido"),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            itemCount: skusPendentes.length,
            itemBuilder: (context, index) {
              final sku = skusPendentes[index];
              return _ConferidoSkuCard(
                sku: sku,
                isCompact: isCompact,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SkuConferido {
  const _SkuConferido({
    required this.codProduto,
    required this.descProduto,
    required this.totalQuantidade,
    required this.totalConferido,
    required this.isBlind,
  });

  final String codProduto;
  final String descProduto;
  final int totalQuantidade;
  final int totalConferido;
  final bool isBlind;
}

class _ConferidoSkuCard extends StatelessWidget {
  const _ConferidoSkuCard({
    required this.sku,
    this.isCompact = false,
  });

  final _SkuConferido sku;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final padding = isCompact ? 12.0 : 16.0;

    return Card(
      margin: EdgeInsets.symmetric(vertical: isCompact ? 3.0 : 4.0),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: padding, vertical: isCompact ? 6 : 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    sku.codProduto,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: isCompact ? 13 : 14,
                    ),
                  ),
                  if (!sku.isBlind && sku.descProduto.isNotEmpty) ...[
                    SizedBox(height: isCompact ? 2 : 4),
                    Text(
                      sku.descProduto,
                      style: TextStyle(
                        fontSize: isCompact ? 11 : 12,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Builder(
              builder: (context) {
                final cor = sku.totalConferido < sku.totalQuantidade
                    ? Colors.orange
                    : Colors.red;
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 8 : 12,
                    vertical: isCompact ? 4 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: cor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: cor),
                  ),
                  child: Text(
                    "${sku.totalConferido}",
                    style: TextStyle(
                      fontSize: isCompact ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: cor.shade800,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmacaoConferenciaDialog extends StatelessWidget {
  const _ConfirmacaoConferenciaDialog({
    required this.pedido,
    required this.itens,
  });

  final OrderCheckModel pedido;
  final List<OrderCheckItemModel> itens;

  @override
  Widget build(BuildContext context) {
    // Considera todos os itens do pedido: divergência quando conferido != quantidade
    final temDivergencia = itens.any((i) => i.conferido != i.quantidade);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 360;
    final insetPadding = isCompact
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 16)
        : const EdgeInsets.symmetric(horizontal: 24, vertical: 24);

    return AlertDialog(
      insetPadding: insetPadding,
      title: Row(
        children: [
          Expanded(
            child: Text(
              "Confirmar conferência",
              style: TextStyle(fontSize: isCompact ? 18 : 24),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(false),
            icon: const Icon(Icons.close),
            tooltip: "Fechar",
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pedido ${pedido.pedido} - ${pedido.cliente}",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  fontSize: isCompact ? 12 : 14,
                ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          SizedBox(height: isCompact ? 12 : 16),
          Container(
            padding: EdgeInsets.all(isCompact ? 12 : 16),
            decoration: BoxDecoration(
              color:
                  temDivergencia ? Colors.orange.shade50 : Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: temDivergencia
                    ? Colors.orange.shade200
                    : Colors.green.shade200,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  temDivergencia
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_outline,
                  color: temDivergencia
                      ? Colors.orange.shade700
                      : Colors.green.shade700,
                  size: isCompact ? 24 : 28,
                ),
                SizedBox(width: isCompact ? 10 : 12),
                Expanded(
                  child: Text(
                    temDivergencia
                        ? "Há produtos com quantidades conferidas diferentes do pedido"
                        : "Todas as quantidades conferidas estão corretas",
                    style: TextStyle(
                      color: temDivergencia
                          ? Colors.orange.shade900
                          : Colors.green.shade900,
                      fontWeight: FontWeight.w600,
                      fontSize: isCompact ? 13 : 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isCompact ? 12 : 16),
        ],
      ),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Cancelar"),
        ),
        const SizedBox(width: 8),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(isCompact ? "Confirmar" : "Confirmar"),
        ),
      ],
    );
  }
}
