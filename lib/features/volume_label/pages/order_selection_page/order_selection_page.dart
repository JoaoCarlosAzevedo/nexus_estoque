import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/form_input_no_keyboard_search_widget.dart';

class VolumeOrderSelectionPage extends ConsumerStatefulWidget {
  const VolumeOrderSelectionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VolumeOrderSelectionPageState();
}

class _VolumeOrderSelectionPageState
    extends ConsumerState<VolumeOrderSelectionPage> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Seleção de Pedido")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              NoKeyboardTextSearchForm(
                label: 'Pesquisa número pedido',
                autoFocus: true,
                onSubmitted: (e) {
                  context.push('/etiqueta_volume_pedido/$e');
                  controller.clear();
                },
                controller: controller,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ElevatedButton(
          onPressed: () {
            context.push('/etiqueta_volume_pedido/${controller.text}');
            controller.clear();
          },
          child: SizedBox(
            height: height / 15,
            width: double.infinity,
            child: const Center(child: Text("Confirmar")),
          ),
        ),
      ),
    );
  }
}
