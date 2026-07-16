import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  // Instance private dan terpusat
  static const _storage = FlutterSecureStorage();


  // Fungsi untuk menyimpan token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  static Future<void> saveOrderId(String orderId) async {
    await _storage.write(key: 'order_id', value: orderId);
  }

  // Fungsi untuk mengambil token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  static Future<String?> getOrderId() async {
    return await _storage.read(key: 'order_id');
  }

  // Fungsi untuk menghapus token (Logout)
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }

  static Future<void> deleteOrderId() async {
    await _storage.delete(key: 'order_id');
  }
}
