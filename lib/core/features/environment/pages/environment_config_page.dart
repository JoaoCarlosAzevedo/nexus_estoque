import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_estoque/core/features/bluetooth_printer/bluetooth_printer.dart';
import 'package:nexus_estoque/core/services/secure_store.dart';

import '../../../services/bt_printer.dart';

class EnvironmentConfigPage extends ConsumerStatefulWidget {
  const EnvironmentConfigPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EnvironmentConfigPageState();
}

class _EnvironmentConfigPageState extends ConsumerState<EnvironmentConfigPage> {
  final TextEditingController urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setUrl();
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  void setUrl() async {
    String url = await LocalStorage.getURL();
    urlController.text = url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuração"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  label: Text("URL do webservice"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () async {
                        await LocalStorage.saveURL(urlController.text);
                        // ignore: use_build_context_synchronously
                        context.pop();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Center(
                          child: Text("Salvar"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await BluetoothPrinter.disconnect();

                  // ignore: use_build_context_synchronously
                  BluetoothPageModal.show(context);
                },
                icon: const Icon(Icons.bluetooth),
                label: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(
                    child: Text("Configurar Impressora BT"),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  context.push('/configuracoes/impressora_rede');
                },
                icon: const Icon(Icons.wifi),
                label: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(
                    child: Text("Configurar Impressora Rede"),
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
