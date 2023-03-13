import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/environment/provider/local_environment_provider.dart';
import 'package:nexus_estoque/core/features/environment/provider/remote_environment_provider.dart';
import 'package:nexus_estoque/core/features/environment/provider/url_provider.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final futureProvider =
        ref.watch(remoteEnvrionmentProvider(urlController.text));
    final urlFutureProvider = ref.watch(localEnvrionmentProvider);
    final urlProv = ref.watch(urlProvider);

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
              futureProvider.when(
                data: (data) {
                  return data.isNotEmpty
                      ? const Text("URL ok!")
                      : const Text("URL Errada");
                },
                error: (error, stack) => Center(child: Text(error.toString())),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
              urlFutureProvider.when(
                data: (data) => Text(data),
                error: (Object error, StackTrace stackTrace) => Text(
                  error.toString(),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
              Text("Provider: $urlProv"),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
