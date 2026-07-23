import 'package:shared_preferences/shared_preferences.dart';

enum PrintMode { bluetooth, network }

class PrintConfig {
  static const _kMode = 'print_mode';
  static const _kUrl = 'printer_url';

  static Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  static Future<PrintMode> getMode() async {
    final prefs = await _prefs();
    final raw = prefs.getString(_kMode);
    if (raw == PrintMode.network.name) return PrintMode.network;
    return PrintMode.bluetooth;
  }

  static Future<void> setMode(PrintMode mode) async {
    final prefs = await _prefs();
    await prefs.setString(_kMode, mode.name);
  }

  static Future<String> getUrl() async {
    final prefs = await _prefs();
    return prefs.getString(_kUrl) ?? '';
  }

  static Future<void> setUrl(String url) async {
    final prefs = await _prefs();
    await prefs.setString(_kUrl, url.trim());
  }
}
