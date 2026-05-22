import 'dart:async';

import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:flutter/material.dart';

import '../../services/bt_printer.dart';

class BluetoothPageModal {
  // ignore: strict_top_level_inference
  static Future<bool> show(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const FractionallySizedBox(
          heightFactor: 0.7,
          child: BluetoothPage(),
        );
      },
    );

    return result ?? false;
  }
}

class BluetoothPage extends StatelessWidget {
  const BluetoothPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _connected = false;
  bool _isScanning = false;
  bool _isLoading = false;
  BluetoothDevice? _device;
  List<BluetoothDevice> _scanResults = [];
  StreamSubscription<ConnectState>? _connectStateSubscription;
  StreamSubscription<List<BluetoothDevice>>? _scanResultsSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  @override
  void dispose() {
    _connectStateSubscription?.cancel();
    _scanResultsSubscription?.cancel();
    super.dispose();
  }

  Future<void> startScanning() async {
    setState(() {
      _isScanning = true;
    });
    await BluetoothPrintPlus.startScan(timeout: const Duration(seconds: 30));
  }

  Future<void> initBluetooth() async {
    _connected = BluetoothPrintPlus.isConnected;

    _connectStateSubscription =
        BluetoothPrintPlus.connectState.listen((connectState) {
      switch (connectState) {
        case ConnectState.connected:
          setState(() {
            _connected = true;
            _isLoading = false;
          });
          break;
        case ConnectState.disconnected:
          setState(() {
            _connected = false;
            _isLoading = false;
            _device = null;
          });
          break;
      }
    });

    _scanResultsSubscription =
        BluetoothPrintPlus.scanResults.listen((devices) {
      if (!mounted) return;
      setState(() {
        _scanResults = devices;
      });
    });

    if (!mounted) return;

    if (_connected) {
      setState(() {
        _isLoading = false;
      });
    }

    await startScanning();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuração Impressora'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text(
              "Status Conexão: $_connected",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            if (_device != null && _connected)
              Text(
                "Dipositivo Conectado: ${_device!.name}",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            const SizedBox(height: 15),
            _isLoading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _isScanning
                    ? Expanded(
                        child: ListView(
                          children: _scanResults
                              .map(
                                (d) => Container(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                    bottom: 5,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(d.name),
                                            Text(
                                              d.address,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const Divider(),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      if (!_connected)
                                        ElevatedButton(
                                          onPressed: () async {
                                            await BluetoothPrintPlus.stopScan();
                                            _device = d;
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            await BluetoothPrintPlus.connect(d);
                                          },
                                          child: const Text("Conectar"),
                                        ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      )
                    : const Text("Not Scanning"),
            if (_connected)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  child: const Text(
                    "Desconectar",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await BluetoothPrinter.disconnect();
                  },
                ),
              ),
            if (_connected)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  child: const Text("Fechar", style: TextStyle(fontSize: 16)),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ),
            if (!_connected)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  child: const Text(
                    "Buscar Dispositivos",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () async {
                    setState(() {
                      _isScanning = true;
                    });
                    await startScanning();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
