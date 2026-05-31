import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';
import 'expense_provider.dart';
import 'budget_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final auth = context.read<AuthProvider>();
      final userId = auth.currentUser!.uid;

      context.read<ExpenseProvider>().listenToExpenses(userId);
      context.read<BudgetProvider>().listenBudget(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();
    final budgetProvider = context.watch<BudgetProvider>();

    final budget = budgetProvider.budget;
    final expenses = expenseProvider.expenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),

      body: budget == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -----------------------
                  // 💰 BUDGET CARD
                  // -----------------------
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Monthly Budget",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "Limit: Rs ${budget.limit}",
                          ),
                          Text(
                            "Spent: Rs ${budget.spent}",
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            "Remaining: Rs ${budget.remaining}",
                            style: const TextStyle(
                              color: Colors.green,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // -----------------------
                          // 📊 PROGRESS BAR
                          // -----------------------
                          LinearProgressIndicator(
                            value: budget.percentUsed / 100,
                            minHeight: 10,
                            backgroundColor: Colors.grey[300],
                            color: budget.percentUsed > 80
                                ? Colors.red
                                : Colors.green,
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "${budget.percentUsed.toStringAsFixed(1)}% used",
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // -----------------------
                  // 📉 QUICK STATS
                  // -----------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statBox(
                        "Total Expenses",
                        expenses.length.toString(),
                        Icons.list,
                      ),
                      _statBox(
                        "Today",
                        _todaySpent(expenses).toString(),
                        Icons.today,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // -----------------------
                  // 🧾 RECENT EXPENSES
                  // -----------------------
                  const Text(
                    "Recent Expenses",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ...expenses.take(5).map((e) {
                    return Card(
                      child: ListTile(
                        title: Text(e.title),
                        subtitle: Text(e.category),
                        trailing: Text(
                          "Rs ${e.amount}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }

  // -----------------------
  // SMALL STAT WIDGET
  // -----------------------
  Widget _statBox(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  // -----------------------
  // TODAY SPENDING
  // -----------------------
  double _todaySpent(List expenses) {
    final today = DateTime.now();

    return expenses
        .where((e) =>
            e.date.day == today.day &&
            e.date.month == today.month &&
            e.date.year == today.year)
        .fold(0.0, (sum, e) => sum + e.amount);
  }
}