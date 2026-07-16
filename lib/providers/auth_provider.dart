import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ticket_kcc/models/user_model.dart';
import 'package:ticket_kcc/services/auth_service.dart';
import 'package:ticket_kcc/services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  final AuthService _service = AuthService();
  String? _errorMsg;
  UserModel? _currentUser;
  String? _customerName;

  String? get errorMsg => _errorMsg;
  UserModel? get currentUser => _currentUser;
  bool get isLogin => _currentUser != null;
  String? get customerName => _customerName;
  bool get isAdmin => _currentUser?.role == 'admin';

  set setCustomerName(String name) {
    _customerName = name;
  }

  void clearCustomer() {
    StorageService.deleteOrderId();
    _customerName = null;
  }

  Future<bool> fetchLogin(String email, String password) async {
    try {
      final UserModel? user = await _service.login(email, password);
      _currentUser = user;
      return true;
    } catch (e) {
      _errorMsg = e.toString();
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> fetchRegister({
    required String email,
    required String password,
    required String username,
    String? phone,
  }) async {
    try {
      final Map<String, dynamic> data = await _service.signup(
        email: email,
        password: password,
        username: username,
        phone: phone,
      );
      return data;
    } catch (e) {
      print(e.toString());
    } finally {
      notifyListeners();
    }
    return null;
  }

  void setUserGuest() {
    final UserModel user = UserModel(
      id: '001',
      email: 'guest@gmail.com',
      username: 'guest',
      role: 'user',
    );
    _currentUser = user;
    notifyListeners();
  }

  // Future<UserModel?> fetchUser() async {
  //   try {
  //     final UserModel? user = await _service.getUser();
  //     _currentUser = user;
  //     notifyListeners();
  //     return user;
  //   } catch (e) {
  //     _errorMsg = e.toString();
  //     notifyListeners();
  //     return null;
  //   }
  // }

  Future<void> processLogout() async {
    // Panggil service
    await _service.logout();
    print('logout dijalankan...');

    // Kosongkan data user di memori state
    _currentUser = null;

    // Beritahu UI agar kembali ke halaman Login
    notifyListeners();
  }
}
