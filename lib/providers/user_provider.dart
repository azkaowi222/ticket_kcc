import 'package:flutter/material.dart';
import 'package:ticket_kcc/models/user_model.dart';
import 'package:ticket_kcc/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> getProfile() async {
    _isLoading = true;
    _user = null;

    notifyListeners();
    try {
      final UserModel _userModel = await _userService.profile();
      _user = _userModel;
      notifyListeners();
    } catch (e, stack) {
      throw Exception('$e, $stack');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editProfile({
    required String email,
    required String username,
    String? phone,
    String? password,
  }) async {
    try {
      if (user != null) {
        final UserModel _userModel = await _userService.updateProfile(
          email: email,
          username: username,
          phone: phone,
          password: password,
        );
        _user = _userModel;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}
