import 'package:bluetooth_print_plus/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';

import '../../services/bt_printer.dart';

class BluetoothPageModal {
  static Future<bool> show(context) async {
    {
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

      if (result != null) {
        return result;
      } else {
        return false;
      }
    }
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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _bluetoothPrintPlus = BluetoothPrintPlus.instance;
  bool _connected = false;
  bool _iscanning = false;
  bool _isLoading = false;
  BluetoothDevice? _device;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  Future<void> startScanning() async {
    setState(() {
      _iscanning = true;
    });
    await _bluetoothPrintPlus.isAvailable;
    await _bluetoothPrintPlus.startScan(timeout: const Duration(seconds: 30));
  }

  Future<void> initBluetooth() async {
    bool isConnected = await _bluetoothPrintPlus.isConnected ?? false;
    _bluetoothPrintPlus.state.listen((state) {
      switch (state) {
        case BluetoothPrintPlus.CONNECTED:
          setState(() {
            _connected = true;
            _isLoading = false;
            if (_device == null) return;
            /*  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return FunctionPage(_device!);
            })); */
            //Navigator.pop(context, true);
          });
          break;
        case BluetoothPrintPlus.DISCONNECTED:
          setState(() {
            _connected = false;
            _isLoading = false;
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected) {
      setState(() {
        _connected = true;
        _isLoading = false;
      });
    }

    startScanning();
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
            //if (_isLoading) const CircularProgressIndicator(),
            Text(
              "Status Conexão: $_connected",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            if (_device != null && _connected)
              Text(
                "Dipositivo Conectado: ${_device!.name!}",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            const SizedBox(
              height: 15,
            ),
            _isLoading
                ? const Expanded(
                    child: Center(
                    child: CircularProgressIndicator(),
                  ))
                : _iscanning
                    ? Expanded(
                        child: StreamBuilder<List<BluetoothDevice>>(
                        stream: _bluetoothPrintPlus.scanResults,
                        initialData: const [],
                        builder: (c, snapshot) => ListView(
                          children: snapshot.data!
                              .map((d) => Container(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(d.name ?? ''),
                                            Text(
                                              d.address ?? 'null',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                            const Divider(),
                                          ],
                                        )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        if (!_connected)
                                          ElevatedButton(
                                            onPressed: () async {
                                              _bluetoothPrintPlus.stopScan();
                                              _bluetoothPrintPlus.connect(d);
                                              _device = d;
                                              setState(() {
                                                _isLoading = true;
                                              });
                                            },
                                            child: const Text("Conectar"),
                                          )
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ))
                    : const Text("Not Scanning"),
            if (_connected)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  child:
                      const Text("Desconectar", style: TextStyle(fontSize: 16)),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    final aux = await BluetoothPrinter.disconnect();
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
                  onPressed: () async {
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
                  child: const Text("Buscar Dispositivos",
                      style: TextStyle(fontSize: 16)),
                  onPressed: () async {
                    setState(() {
                      _iscanning = true;
                    });
                    await _bluetoothPrintPlus.isAvailable;
                    await _bluetoothPrintPlus.startScan(
                        timeout: const Duration(seconds: 30));
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
