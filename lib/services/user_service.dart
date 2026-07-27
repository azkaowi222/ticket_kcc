import 'dart:convert';

import 'package:ticket_kcc/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_kcc/services/api_service.dart';
import 'package:ticket_kcc/services/storage_service.dart';

class UserService {
  Future<UserModel> profile() async {
    try {
      final token = await StorageService.getToken();
      print('token from userservice: $token');
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/users/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw Exception(data['message']);
      }
      final UserModel _userModel = UserModel.fromLoginJson(data);
      return _userModel;
    } catch (e, stack) {
      throw Exception('$e, $stack');
    }
  }

  Future<UserModel> updateProfile({
    required String email,
    required String username,
    String? phone,
    String? password,
  }) async {
    try {
      final token = await StorageService.getToken();
      final response = await http.patch(
        Uri.parse('${ApiService.baseUrl}/users/edit'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'username': username,
          'phone': phone,
          'password': password,
        }),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw Exception(data['message']);
      }
      final UserModel _userModel = UserModel.fromLoginJson(data);
      return _userModel;
    } catch (e) {
      throw Exception(e);
    }
  }
}
