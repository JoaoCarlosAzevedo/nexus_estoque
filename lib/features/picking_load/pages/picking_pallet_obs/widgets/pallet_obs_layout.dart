import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/picking_pallet_obs_cubit.dart';
import 'pallet_obs_panel.dart';

class PalletObsLayout extends StatelessWidget {
  const PalletObsLayout({
    required this.child,
    required this.enablePanel,
    super.key,
  });

  final Widget child;
  final bool enablePanel;

  @override
  Widget build(BuildContext context) {
    if (!enablePanel) {
      return child;
    }

    return BlocBuilder<PickingPalletObsCubit, PickingPalletObsState>(
      builder: (context, state) {
        if (!state.panelVisible) {
          return child;
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            //final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

            final maxPanelHeight =
                (constraints.maxHeight * 0.85).clamp(120.0, 300.0);

            return Column(
              children: [
                Expanded(child: child),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxPanelHeight),
                  child: const PalletObsPanel(),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class PalletObsAppBarAction extends StatelessWidget {
  const PalletObsAppBarAction({
    required this.enablePanel,
    super.key,
  });

  final bool enablePanel;

  @override
  Widget build(BuildContext context) {
    if (!enablePanel) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<PickingPalletObsCubit, PickingPalletObsState>(
      builder: (context, state) {
        if (state.panelVisible) {
          return const SizedBox.shrink();
        }

        return IconButton(
          onPressed: () => context.read<PickingPalletObsCubit>().showPanel(),
          icon: const Icon(Icons.inventory_2_outlined),
          tooltip: "Observação de Pallet",
        );
      },
    );
  }
}
