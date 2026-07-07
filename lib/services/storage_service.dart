import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  // Instance private dan terpusat
  static const _storage = FlutterSecureStorage();

  // Fungsi untuk menyimpan token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // Fungsi untuk mengambil token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Fungsi untuk menghapus token (Logout)
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }
}
