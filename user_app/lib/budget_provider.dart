import 'package:flutter/material.dart';
import 'budget_model.dart';
import 'budget_service.dart';

class BudgetProvider extends ChangeNotifier {
  final BudgetService _service = BudgetService();

  BudgetModel? _budget;
  BudgetModel? get budget => _budget;

  void listenBudget(String userId) {
    _service.getBudget(userId).listen((data) {
      _budget = data;
      notifyListeners();
    });
  }
}