import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/pallet_obs_item.dart';
import '../cubit/picking_pallet_obs_cubit.dart';

class PalletObsPanel extends StatefulWidget {
  const PalletObsPanel({super.key});

  @override
  State<PalletObsPanel> createState() => _PalletObsPanelState();
}

class _PalletObsPanelState extends State<PalletObsPanel> {
  final TextEditingController _observationController = TextEditingController();
  bool _expanded = false;

  static const double _headerHeight = 45;

  @override
  void dispose() {
    _observationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PickingPalletObsCubit, PickingPalletObsState>(
      listener: (context, state) {
        if (state.status == PalletObsStatus.success) {
          _observationController.clear();
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {
            _expanded = false;
          });
          context.read<PickingPalletObsCubit>().resetStatus();
        }

        if (state.status == PalletObsStatus.error &&
            (state.errorMessage ?? '').isNotEmpty) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            desc: state.errorMessage,
            btnOkOnPress: () {},
            btnOkColor: Theme.of(context).primaryColor,
          ).show();
          context.read<PickingPalletObsCubit>().resetStatus();
        }
      },
      builder: (context, state) {
        if (!state.panelVisible) {
          return const SizedBox.shrink();
        }

        final items = state.items;
        final isSending = state.status == PalletObsStatus.sending;
        final theme = Theme.of(context);
        final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

        return LayoutBuilder(
          builder: (context, constraints) {
            final maxHeight = constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : MediaQuery.sizeOf(context).height * 0.45;
            const formHeight = 118.0;
            final listHeight = keyboardOpen
                ? 0.0
                : (maxHeight - _headerHeight - formHeight)
                    .clamp(0.0, maxHeight - _headerHeight - formHeight);

            return Material(
              elevation: 8,
              color: theme.cardColor,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: _headerHeight,
                      child: InkWell(
                        onTap: isSending
                            ? null
                            : () {
                                setState(() {
                                  _expanded = !_expanded;
                                });
                              },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Icon(Icons.inventory_2_outlined,
                                  color: theme.primaryColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Pallet (${items.length} ${items.length == 1 ? 'item' : 'itens'})",
                                  style: theme.textTheme.titleMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                _expanded
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_up,
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                tooltip: "Fechar observação de pallet",
                                onPressed: isSending
                                    ? null
                                    : () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        context
                                            .read<PickingPalletObsCubit>()
                                            .hidePanel();
                                      },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_expanded)
                      Expanded(
                        child: Column(
                          children: [
                            if (!keyboardOpen && listHeight > 0) ...[
                              const Divider(height: 1),
                              Expanded(
                                child: items.isEmpty
                                    ? Center(
                                        child: Text(
                                          "Nenhum item separado ainda.",
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      )
                                    : ListView.separated(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        itemCount: items.length,
                                        separatorBuilder: (_, __) =>
                                            const Divider(height: 1),
                                        itemBuilder: (context, index) {
                                          final item = items[index];
                                          return _PalletObsItemTile(
                                            item: item,
                                            onRemove: isSending
                                                ? null
                                                : () => context
                                                    .read<
                                                        PickingPalletObsCubit>()
                                                    .removeItem(item),
                                          );
                                        },
                                      ),
                              ),
                              const Divider(height: 1),
                            ],
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                              child: TextField(
                                controller: _observationController,
                                enabled: !isSending,
                                minLines: 1,
                                maxLines: keyboardOpen ? 1 : 3,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                  labelText: "Observação",
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: isSending || items.isEmpty
                                      ? null
                                      : () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          context
                                              .read<PickingPalletObsCubit>()
                                              .sendObservacao(
                                                  _observationController.text);
                                        },
                                  icon: isSending
                                      ? const SizedBox(
                                          width: 10,
                                          height: 10,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.send),
                                  label: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 0),
                                    child: Text("Enviar Observação de Pallet"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _PalletObsItemTile extends StatelessWidget {
  const _PalletObsItemTile({required this.item, required this.onRemove});

  final PalletObsItem item;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final quantidadeLabel = item.quantidade % 1 == 0
        ? item.quantidade.toInt().toString()
        : item.quantidade.toString();

    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      title: Text(
        "Pedido ${item.pedido}  •  ${item.codigo}",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.descricao.isNotEmpty)
            Text(
              item.descricao,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          Text(
            "Qtd: $quantidadeLabel",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.close, size: 20),
        tooltip: "Remover",
        onPressed: onRemove,
      ),
    );
  }
}
