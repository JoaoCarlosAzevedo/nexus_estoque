import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/bt_printer.dart';
import '../../../services/print_config.dart';

class NetworkPrinterConfigPage extends ConsumerStatefulWidget {
  const NetworkPrinterConfigPage({super.key});

  @override
  ConsumerState<NetworkPrinterConfigPage> createState() =>
      _NetworkPrinterConfigPageState();
}

class _NetworkPrinterConfigPageState
    extends ConsumerState<NetworkPrinterConfigPage> {
  final TextEditingController printerUrlController = TextEditingController();

  static const Color _accent = Color(0xFF2E7D32);
  static const Color _accentLight = Color(0xFFE8F5E9);

  bool _networkEnabled = false;
  bool _checkingStatus = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    printerUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    final mode = await PrintConfig.getMode();
    final url = await PrintConfig.getUrl();
    if (!mounted) return;
    setState(() {
      _networkEnabled = mode == PrintMode.network;
      printerUrlController.text = url;
      _loading = false;
    });
  }

  Future<void> _onToggleNetwork(bool value) async {
    await PrintConfig.setMode(
      value ? PrintMode.network : PrintMode.bluetooth,
    );
    if (!mounted) return;
    setState(() {
      _networkEnabled = value;
    });
  }

  Future<void> _savePrinterUrl() async {
    final messenger = ScaffoldMessenger.of(context);
    await PrintConfig.setUrl(printerUrlController.text);
    messenger.showSnackBar(
      const SnackBar(content: Text('URL da impressora salva.')),
    );
  }

  Future<void> _checkNetworkStatus() async {
    final messenger = ScaffoldMessenger.of(context);
    final url = printerUrlController.text.trim();
    if (url.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Informe a URL da impressora.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _checkingStatus = true;
    });

    final ok = await BluetoothPrinter.pingNetworkPrinter(url);

    if (!mounted) return;
    setState(() {
      _checkingStatus = false;
    });

    messenger.showSnackBar(
      SnackBar(
        content: Text(ok ? 'Conectado' : 'Falha ao conectar'),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impressora Rede'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStatusCard(),
                    const SizedBox(height: 20),
                    TextField(
                      controller: printerUrlController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        label: Text('URL Impressora'),
                        hintText: 'http://192.168.0.10:8080/print',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _savePrinterUrl,
                            child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Center(child: Text('Salvar URL')),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                _checkingStatus ? null : _checkNetworkStatus,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Center(
                                child: _checkingStatus
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Checar Status'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _networkEnabled ? _accentLight : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _networkEnabled ? _accent : Colors.grey.shade400,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.wifi,
                color: _networkEnabled ? _accent : Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Impressora de rede',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _networkEnabled ? _accent : Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Switch(
                inactiveTrackColor: Colors.grey.shade400,
                value: _networkEnabled,
                activeColor: _accent,
                onChanged: _onToggleNetwork,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Text(
              _networkEnabled
                  ? 'Ativado. As etiquetas serão enviadas via HTTP.'
                  : 'Desativado. As etiquetas serão enviadas via Bluetooth.',
              style: TextStyle(
                color: _networkEnabled ? _accent : Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
