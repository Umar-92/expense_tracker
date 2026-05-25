import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';
import 'user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  User? get currentUser => _authService.getCurrentUser();

  // SIGN UP
  Future<UserModel?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    UserModel? user = await _authService.signup(
      name: name,
      email: email,
      password: password,
    );

    _isLoading = false;
    notifyListeners();

    return user;
  }

  // LOGIN
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    User? user = await _authService.login(
      email: email,
      password: password,
    );

    _isLoading = false;
    notifyListeners();

    return user;
  }

  // LOGOUT
  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }
}