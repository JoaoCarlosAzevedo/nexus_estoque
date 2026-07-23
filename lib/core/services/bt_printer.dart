import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_print_plus/bluetooth_print_model.dart';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../features/bluetooth_printer/bluetooth_printer.dart';
import '../features/bluetooth_printer/command_tool.dart';
import 'print_config.dart';

class BluetoothPrinter {
  static String? _lastNetworkError;

  static String? get lastNetworkError => _lastNetworkError;

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
    final mode = await PrintConfig.getMode();
    if (mode == PrintMode.network) {
      return _printNetwork(zpl);
    }
    return _printBluetooth(zpl);
  }

  static Future<bool> _printBluetooth(String zpl) async {
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

  static Future<bool> _printNetwork(String zpl) async {
    _lastNetworkError = null;
    try {
      final url = (await PrintConfig.getUrl()).trim();
      if (url.isEmpty) {
        _lastNetworkError = 'URL da impressora não configurada.';
        return false;
      }

      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        validateStatus: (_) => true,
        contentType: 'application/json',
      ));

      final response = await dio.post(
        url,
        data: {'zpl': zpl},
      );
      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        return true;
      }

      final body = response.data;
      final bodyStr = body is String
          ? body
          : (body != null ? body.toString() : '');
      _lastNetworkError =
          'HTTP $code em $url${bodyStr.isNotEmpty ? "\n\n$bodyStr" : ""}';
      return false;
    } on DioException catch (e) {
      final msg = e.message ?? e.error?.toString() ?? e.toString();
      _lastNetworkError = 'Falha de rede: $msg';
      return false;
    } catch (e) {
      _lastNetworkError = 'Erro inesperado: $e';
      return false;
    }
  }

  static Future<bool> pingNetworkPrinter(String url) async {
    final target = url.trim();
    if (target.isEmpty) return false;
    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        validateStatus: (_) => true,
      ));
      final response = await dio.get(target);
      final code = response.statusCode ?? 0;
      return code >= 200 && code < 300;
    } catch (_) {
      return false;
    }
  }

  /// Mostra o feedback correto de falha de impressão conforme o modo atual:
  /// - Bluetooth: abre o modal de configuração da impressora BT.
  /// - Rede: exibe um AlertDialog com a mensagem de erro do POST.
  static Future<void> showPrintErrorFeedback(BuildContext context) async {
    final mode = await PrintConfig.getMode();
    if (!context.mounted) return;
    if (mode == PrintMode.bluetooth) {
      await BluetoothPageModal.show(context);
      return;
    }

    final message = _lastNetworkError ??
        'Falha ao enviar ZPL para a impressora de rede.';
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Expanded(child: Text('Falha na impressão via rede')),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(message),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  static Future<void> print(String zpl, BuildContext context) async {
    final isPrinted = await BluetoothPrinter.printZPL(zpl);
    if (isPrinted) return;
    if (!context.mounted) return;
    // ignore: use_build_context_synchronously
    await showPrintErrorFeedback(context);
  }
}
