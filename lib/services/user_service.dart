import 'dart:convert';

import 'package:ticket_kcc/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_kcc/services/api_service.dart';
import 'package:ticket_kcc/services/storage_service.dart';

class UserService {
  Future<UserModel> profile() async {
    try {
      final token = await StorageService.getToken();
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
}
