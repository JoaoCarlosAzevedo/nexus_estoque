import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_print_plus/bluetooth_print_model.dart';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:flutter/widgets.dart';

import '../features/bluetooth_printer/bluetooth_printer.dart';
import '../features/bluetooth_printer/command_tool.dart';

class BluetoothPrinter {
  static Future<bool> isConnected() async {
    return await BluetoothPrintPlus.instance.isConnected ?? false;
  }

  Stream<List<BluetoothDevice>>? scannDevices() {
    return BluetoothPrintPlus.instance.scanResults;
  }

  static void startScann() async {
    await BluetoothPrintPlus.instance.isAvailable;
    await BluetoothPrintPlus.instance.startScan(
      timeout: const Duration(seconds: 30),
    );
  }

  static Future<dynamic> connect(BluetoothDevice device) async {
    await BluetoothPrintPlus.instance.stopScan();
    await BluetoothPrintPlus.instance.connect(device);
  }

  static Future<dynamic> disconnect() async {
    await BluetoothPrintPlus.instance.disconnect();
  }

  static Future<dynamic> testPrinter() async {
    final cmd = await CommandTool.tscSelfTestCmd();
    BluetoothPrintPlus.instance.write(cmd);
  }

  static Future<bool> printTest() {
    String source = "^XA ^CF0,60 ^FO160,50^FDTESTE DE ETIQUETA^FS^XZ";
    final response = printZPL(source);
    return response;
  }

  static Future<bool> printZPL(String zpl) async {
    try {
      List<int> list = utf8.encode(zpl);
      Uint8List bytes = Uint8List.fromList(list);

      final response = await BluetoothPrintPlus.instance.write(bytes);
      if (response == null) {
        return true;
      } else {
        return false;
      }
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
