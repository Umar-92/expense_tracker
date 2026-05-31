import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';
import 'user_model.dart';
import 'budget_service.dart';
import 'budget_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final BudgetService _budgetService = BudgetService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? get currentUser => _authService.getCurrentUser();

  // -------------------------------
  // SIGN UP
  // -------------------------------
  Future<UserModel?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userModel = await _authService.signup(
        name: name,
        email: email,
        password: password,
      );

      // 🔥 INIT BUDGET AFTER SIGNUP
      if (userModel != null) {
        await _initBudget(userModel.uid);
      }

      return userModel;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -------------------------------
  // LOGIN
  // -------------------------------
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    final user = await _authService.login(
      email: email,
      password: password,
    );

    // 🔥 INIT BUDGET AFTER LOGIN
    if (user != null) {
      await _initBudget(user.uid);
    }

    _isLoading = false;
    notifyListeners();

    return user;
  }

  // -------------------------------
  // LOGOUT
  // -------------------------------
  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }

  // -------------------------------
  // BUDGET INITIALIZATION (SAFE)
  // -------------------------------
  Future<void> _initBudget(String userId) async {
    final doc = await _budgetService.getBudgetDoc(userId);

    if (!doc.exists) {
      await _budgetService.setBudget(
        userId,
        BudgetModel(
          id: 'current',
          category: 'Monthly',
          limit: 50000,
          spent: 0,
        ),
      );
    }
  }
}