import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@singleton
class AppStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  AppStorage();

  Future<void> write(String key, String? value) {
    return storage.write(key: key, value: value);
  }

  Future<String?> read(String key) => storage.read(key: key);

  Future<bool> containsKey(String key) => storage.containsKey(key: key);

  Future<Map<String, String>> readAll() => storage.readAll();

  Future<void> delete(String key) => storage.delete(key: key);

  Future<void> deleteAll() => storage.deleteAll();
}
