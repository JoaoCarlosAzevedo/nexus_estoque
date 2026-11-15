import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_estoque/core/features/searches/products/pages/products_search_page.dart';
import 'package:nexus_estoque/core/widgets/form_input_no_keyboard_search_widget.dart';

class ProductBalanceScanPage extends StatefulWidget {
  const ProductBalanceScanPage({super.key});

  @override
  State<ProductBalanceScanPage> createState() => _ProductBalanceScanPageState();
}

class _ProductBalanceScanPageState extends State<ProductBalanceScanPage> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focus = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focus.dispose();
    super.dispose();
  }

  Future<void> _openProductBalance(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      controller.clear();
      await context.push('/saldo_produto/${Uri.encodeComponent(trimmed)}');
      if (!mounted) return;
      focus.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saldo por Produto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: NoKeyboardTextSearchForm(
          label: 'Produto',
          autoFocus: true,
          focusNode: focus,
          controller: controller,
          onSubmitted: _openProductBalance,
          prefixIcon: IconButton(
            onPressed: () async {
              final code = await ProductSearchModal.show(context, false);
              await _openProductBalance(code);
            },
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
          ),
        ),
      ),
    );
  }
}
