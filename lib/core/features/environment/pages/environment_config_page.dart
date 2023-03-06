import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/constants/secure_store.dart';
import 'package:nexus_estoque/core/features/environment/provider/remote_environment_provider.dart';

class EnvironmentConfigPage extends ConsumerStatefulWidget {
  const EnvironmentConfigPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EnvironmentConfigPageState();
}

class _EnvironmentConfigPageState extends ConsumerState<EnvironmentConfigPage> {
  final TextEditingController urlController = TextEditingController();
  bool enable = false;

  late UrlStore store;

  @override
  void initState() {
    super.initState();

    store = ref.read(urlStoreProvider);
  }

  @override
  Widget build(BuildContext context) {
    final futureProvider =
        ref.watch(remoteEnvrionmentProvider(urlController.text));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuração"),
      ),
      body: Padding(
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
            futureProvider.when(
              data: (data) {
                enable = data;
                return data ? const Text("URL ok!") : const Text("URL Errada");
              },
              error: (error, stack) => Center(child: Text(error.toString())),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(
                        child: Text("Testar"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: enable
                        ? () {
                            store.saveURL(urlController.text);
                          }
                        : null,
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
          ],
        ),
      ),
    );
  }
}
