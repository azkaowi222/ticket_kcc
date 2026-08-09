import 'dart:convert';
import 'package:ticket_kcc/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_kcc/services/api_service.dart';
import 'package:ticket_kcc/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
    } catch (e) {
      // Menangkap error jaringan (misal: tidak ada internet atau server mati)
      throw Exception(e);
    }
  }

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
      throw Exception(e.toString());
    }
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize();
      final GoogleSignInAccount? _user =
          await GoogleSignIn.instance.authenticate();
      if (_user == null) {
        throw Exception();
      }
      final GoogleSignInAuthentication googleAuth = _user.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final _userAuth = await _auth.signInWithCredential(credential);
      final idToken = await _userAuth.user!.getIdToken();
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/auth/login/google'),
        headers: {'Content-Type': "application/json"},
        body: jsonEncode({'idToken': idToken}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw Exception(data['message']);
      }
      await StorageService.saveToken(data['token']);
      final UserModel _userModel = UserModel.fromLoginJson(data);
      return _userModel;
    } catch (e) {
      throw Exception(e.toString());
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

  Future<bool> verifyEmail({required String email, required int otp}) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/auth/email/verify'),
        headers: {'Content-Type': "application/json"},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        final errMessage = data['message'];
        throw Exception(errMessage as String);
      }
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> resendOtp({required String email}) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiService.baseUrl}/auth/email/resend'),
        headers: {'Content-Type': "application/json"},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        final errMessage = data['message'];
        throw Exception(errMessage as String);
      }
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> updatePassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiService.baseUrl}/auth/update-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        final errMessage = data['message'];
        throw Exception(errMessage as String);
      }
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
