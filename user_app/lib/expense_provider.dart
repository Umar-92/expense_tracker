import 'dart:async';
import 'package:flutter/material.dart';
import 'expense_model.dart';
import 'expense_service.dart';
import 'budget_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final ExpenseService _service = ExpenseService();
  final BudgetService _budgetService = BudgetService();

  List<ExpenseModel> _expenses = [];
  List<ExpenseModel> get expenses => _expenses;

  bool _loading = false;
  bool get loading => _loading;

  StreamSubscription? _subscription;

  // -------------------------------
  // LISTEN EXPENSES (REAL-TIME)
  // -------------------------------
  void listenToExpenses(String userId) {
    _loading = true;
    notifyListeners();

    _subscription?.cancel();

    _subscription = _service.getExpenses(userId).listen((data) async {
      _expenses = data;
      _loading = false;
      notifyListeners();

      // 🔥 AUTO UPDATE BUDGET SPENT
      final totalSpent = _calculateTotalSpent();

      await _budgetService.updateSpent(userId, totalSpent);
    });
  }

  // -------------------------------
  // ADD EXPENSE
  // -------------------------------
  Future<void> addExpense(String userId, ExpenseModel expense) async {
    await _service.addExpense(userId, expense);
  }

  // -------------------------------
  // DELETE EXPENSE
  // -------------------------------
  Future<void> deleteExpense(String userId, String expenseId) async {
    await _service.deleteExpense(userId, expenseId);
  }

  // -------------------------------
  // UPDATE EXPENSE
  // -------------------------------
  Future<void> updateExpense(
    String userId,
    String expenseId,
    ExpenseModel expense,
  ) async {
    await _service.updateExpense(userId, expenseId, expense);
  }

  // -------------------------------
  // TOTAL SPENT CALCULATION
  // -------------------------------
  double _calculateTotalSpent() {
    return _expenses.fold(
      0.0,
      (sum, item) => sum + item.amount,
    );
  }

  // -------------------------------
  // CLEANUP
  // -------------------------------
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}