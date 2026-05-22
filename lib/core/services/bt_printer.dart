import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:flutter/widgets.dart';

import '../features/bluetooth_printer/bluetooth_printer.dart';
import '../features/bluetooth_printer/command_tool.dart';

class BluetoothPrinter {
  static Future<bool> isConnected() async {
    return BluetoothPrintPlus.isConnected;
  }

  Stream<List<BluetoothDevice>> scannDevices() {
    return BluetoothPrintPlus.scanResults;
  }

  static Future<void> startScann() async {
    await BluetoothPrintPlus.startScan(
      timeout: const Duration(seconds: 30),
    );
  }

  static Future<dynamic> connect(BluetoothDevice device) async {
    await BluetoothPrintPlus.stopScan();
    await BluetoothPrintPlus.connect(device);
  }

  static Future<dynamic> disconnect() async {
    await BluetoothPrintPlus.disconnect();
  }

  static Future<dynamic> testPrinter() async {
    final cmd = await CommandTool.tscSelfTestCmd();
    if (cmd != null) {
      await BluetoothPrintPlus.write(cmd);
    }
  }

  static Future<bool> printTest() {
    const source = "^XA ^CF0,60 ^FO160,50^FDTESTE DE ETIQUETA^FS^XZ";
    return printZPL(source);
  }

  static Future<bool> printZPL(String zpl) async {
    try {
      final list = utf8.encode(zpl);
      final bytes = Uint8List.fromList(list);
      await BluetoothPrintPlus.write(bytes);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> print(String zpl, BuildContext context) async {
    final isPrinted = await BluetoothPrinter.printZPL(zpl);
    if (!isPrinted) {}
    // ignore: use_build_context_synchronously
    BluetoothPageModal.show(context);
  }
}
