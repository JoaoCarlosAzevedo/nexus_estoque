import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nexus_estoque/core/features/branches/data/model/branch_model.dart';

//final urlStoreProvider = Provider<LocalStorage>((ref) => LocalStorage());

class LocalStorage {
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  static Future saveURL(String url) async {
    await storage.write(key: 'url', value: url.trim());
  }

  static Future<String> getURL() async {
    final url = await storage.read(key: 'url');
    return url ?? '';
  }

  static Future saveBranch(Branch branch) async {
    await storage.write(key: 'branch', value: branch.toJson());
  }

  static Future<Branch> getBranch() async {
    final branch = await storage.read(key: 'branch');
    return Branch.fromJson(branch!);
  }
}
