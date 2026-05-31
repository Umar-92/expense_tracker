import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/admin_provider.dart';
import '../../models/expense_model.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  String? _selectedCategory;
  String? _selectedUserId;

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Expenses'),
        actions: [
          if (_selectedCategory != null || _selectedUserId != null)
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Clear Filters',
              onPressed: () {
                setState(() {
                  _selectedCategory = null;
                  _selectedUserId = null;
                });
              },
            ),
        ],
      ),
      body: StreamBuilder<List<ExpenseModel>>(
        stream: adminProvider.expensesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allExpenses = snapshot.data ?? [];
          if (allExpenses.isEmpty) {
            return const Center(child: Text('No expenses found.'));
          }

          // Extract unique categories and users for the dropdowns
          final categories = allExpenses.map((e) => e.category).where((c) => c.isNotEmpty).toSet().toList();
          final userIds = allExpenses.map((e) => e.userId).where((u) => u.isNotEmpty).toSet().toList();

          // Apply filters
          final filteredExpenses = allExpenses.where((expense) {
            final matchCategory = _selectedCategory == null || expense.category == _selectedCategory;
            final matchUser = _selectedUserId == null || expense.userId == _selectedUserId;
            return matchCategory && matchUser;
          }).toList();

          return Column(
            children: [
              // Filter Row
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        isExpanded: true,
                        value: _selectedCategory,
                        items: [
                          const DropdownMenuItem(value: null, child: Text('All')),
                          ...categories.map((c) => DropdownMenuItem(value: c, child: Text(c))),
                        ],
                        onChanged: (val) => setState(() => _selectedCategory = val),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'User ID',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        isExpanded: true,
                        value: _selectedUserId,
                        items: [
                          const DropdownMenuItem(value: null, child: Text('All')),
                          ...userIds.map((u) => DropdownMenuItem(value: u, child: Text(u))),
                        ],
                        onChanged: (val) => setState(() => _selectedUserId = val),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredExpenses.isEmpty
                    ? const Center(child: Text('No expenses match the filters.'))
                    : ListView.builder(
                        itemCount: filteredExpenses.length,
                        itemBuilder: (context, index) {
                          final expense = filteredExpenses[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green.shade100,
                              child: const Icon(Icons.attach_money, color: Colors.green),
                            ),
                            title: Text(expense.category.isNotEmpty ? expense.category : 'Uncategorized'),
                            subtitle: Text('User ID: ${expense.userId}\n${DateFormat('yMMMd').format(expense.date)} - ${expense.description}'),
                            isThreeLine: true,
                            trailing: Text(
                              '\$${expense.amount.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
