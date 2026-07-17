import 'dart:convert';
import 'package:ticket_kcc/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_kcc/services/api_service.dart';
import 'package:ticket_kcc/services/storage_service.dart';

class AuthService {
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      // Cek apakah response dari server sukses (HTTP 200 OK)
      if (response.statusCode == 200) {
        // Hapus await di sini
        final data = jsonDecode(response.body);

        // 1. Ambil token dari root JSON dan simpan ke Secure Storage
        final String token = data['token'];
        await StorageService.saveToken(token);

        // 2. Parse data user (karena API mengembalikan { message, token, user })
        final UserModel user = UserModel.fromLoginJson(data);

        return user; // Kembalikan data user ke UI
      } else {
        // Menangkap pesan error dari backend (misal: "Email atau password salah")
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal melakukan login');
      }
    } catch (e, stacktrace) {
      print('ada error: ${e.toString()}');
      print(stacktrace);
      // Menangkap error jaringan (misal: tidak ada internet atau server mati)
      throw Exception('Terjadi kesalahan sistem: $e');
    }
  }

  // Future<UserModel?> getUser() async {
  //   try {
  //     final String? jwtToken = await StorageService.getToken();
  //     final response = await http.get(
  //       Uri.parse('${ApiService.baseUrl}/users/profile'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $jwtToken',
  //       },
  //     );

  //     final data = jsonDecode(response.body);
  //     final UserModel user = UserModel.fromJson(data['user']);

  //     return user;
  //   } catch (e, stacktrace) {
  //     print('ad error ${e.toString()} di ${stacktrace.toString()}');
  //     throw Exception(e.toString());
  //   }
  // }

  Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String username,
    String? phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'phone': phone,
        }),
      );
      final body = jsonDecode(response.body);
      final String message = body['message'];

      if (response.statusCode != 201) {
        throw Exception(message);
      }

      return {'statusCode': response.statusCode, 'message': message};
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> logout() async {
    try {
      // 1. Dapatkan token saat ini untuk dikirim di Header
      final token = await StorageService.getToken();

      // 2. Beritahu backend bahwa user ini logout
      await http.post(
        Uri.parse('${ApiService.baseUrl}/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // 3. (Paling Penting) Hapus token dari brankas HP
      await StorageService.deleteToken();
    } catch (e) {
      print(
        'Gagal memberitahu server, tapi token lokal tetap akan dihapus: $e',
      );
      await StorageService.deleteToken(); // Pastikan selalu terhapus
    }
  }
}
