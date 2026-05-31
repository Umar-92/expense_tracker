import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import '../models/expense_model.dart';

class AdminProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();

  Stream<int> get totalUsersStream => _dbService.getTotalUsersCount();
  Stream<int> get totalExpensesStream => _dbService.getTotalExpensesCount();
  Stream<List<UserModel>> get usersStream => _dbService.getUsers();
  Stream<List<ExpenseModel>> get expensesStream => _dbService.getExpenses();

  Future<void> deleteUser(String userId) async {
    try {
      await _dbService.deleteUser(userId);
    } catch (e) {
      debugPrint('Error deleting user: $e');
    }
  }
}
