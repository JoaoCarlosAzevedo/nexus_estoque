import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class BarcodeScanerPage extends ConsumerStatefulWidget {
  const BarcodeScanerPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BarcodeScanerPageState();
}

class _BarcodeScanerPageState extends ConsumerState<BarcodeScanerPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  bool showKeyboard = false;
  List<String> barcodes = [];

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("passei no build");
    return Scaffold(
      appBar: AppBar(
        title: Text('External Keyboard Input $showKeyboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              controller: _controller,
              focusNode: _focusNode,
              keyboardType:
                  showKeyboard ? TextInputType.text : TextInputType.none,
              textInputAction: TextInputAction.done,
              onSubmitted: (e) {
                log(e);
                barcodes.add(e);
                _controller.clear();
                _focusNode.requestFocus();
                setState(() {});
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      showKeyboard = !showKeyboard;
                      if (showKeyboard) {
                        _focusNode.unfocus();
                        _controller.text = "";
                      } else {
                        Future.delayed(
                          const Duration(milliseconds: 100),
                          () => SystemChannels.textInput
                              .invokeMethod('TextInput.hide'),
                        );
                      }
                    });

                    Future.delayed(const Duration(milliseconds: 500), () {
                      setState(() {
                        if (showKeyboard) {
                          _focusNode.requestFocus();
                        }
                        // Here you can write your code for open new view
                      });
                    });
                  },
                  icon: Icon(
                    Icons.keyboard,
                    color: showKeyboard ? Colors.green : Colors.grey,
                  ),
                ),
                label: const Text("Pesquisar"),
              ),
            ),
            ...barcodes.map((e) => Text(e)),
          ],
        ),
      ),
    );
  }
}
