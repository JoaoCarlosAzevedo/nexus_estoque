import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:nexus_estoque/core/features/searches/products/pages/products_search_page.dart';

import '../../../../core/mixins/validation_mixin.dart';
import '../../../../core/widgets/form_input_no_keyboard_search_widget.dart';

class RepositionV2Page extends StatefulWidget {
  const RepositionV2Page({
    super.key,
  });

  @override
  State<RepositionV2Page> createState() => _RepositionV2PageState();
}

class _RepositionV2PageState extends State<RepositionV2Page>
    with ValidationMixi {
  final TextEditingController controller = TextEditingController();
  final focus = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reposição"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: height / 15, bottom: height / 15),
                child: SizedBox(
                  height: height / 10,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: FaIcon(
                      FontAwesomeIcons.boxesPacking,
                      color: Theme.of(context).primaryColor,
                      size: height / 10,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: NoKeyboardTextSearchForm(
                      label: 'Produto',
                      autoFocus: true,
                      focusNode: focus,
                      onSubmitted: (e) {
                        context.push(
                          '/reposicap_v2_lista/$e',
                        );
                        controller.clear();
                        focus.requestFocus();
                      },
                      validator: isNotEmpty,
                      controller: controller,
                      prefixIcon: IconButton(
                        onPressed: () async {
                          controller.text =
                              await ProductSearchModal.show(context, false);

                          focus.requestFocus();
                        },
                        icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height / 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    context.push(
                      '/reposicap_v2_lista/${controller.text}',
                    );
                    controller.clear();
                  }
                },
                child: SizedBox(
                  height: height / 15,
                  width: double.infinity,
                  child: const Center(child: Text("Confirmar")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
