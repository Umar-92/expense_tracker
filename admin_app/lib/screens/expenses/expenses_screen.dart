import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/admin_provider.dart';
import '../../models/expense_model.dart';
import '../../models/user_model.dart';

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
      body: StreamBuilder<List<UserModel>>(
        stream: adminProvider.usersStream,
        builder: (context, userSnapshot) {
          if (userSnapshot.hasError) {
            return Center(child: Text('Error: ${userSnapshot.error}'));
          }
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allUsers = userSnapshot.data ?? [];

          return StreamBuilder<List<ExpenseModel>>(
            stream: adminProvider.expensesStream,
            builder: (context, expenseSnapshot) {
              if (expenseSnapshot.hasError) {
                return Center(child: Text('Error: ${expenseSnapshot.error}'));
              }
              if (expenseSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final allExpenses = expenseSnapshot.data ?? [];

              // Hardcoded categories from the user app
              final categories = [
                'Food', 'Transport', 'Shopping', 'Bills', 'Health', 'Entertainment', 'Other'
              ];

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
                              labelText: 'Select User',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            isExpanded: true,
                            value: _selectedUserId,
                            items: [
                              const DropdownMenuItem(value: null, child: Text('All Users')),
                              ...allUsers.map((user) {
                                final displayName = user.name.isNotEmpty ? user.name : user.email;
                                return DropdownMenuItem(value: user.id, child: Text(displayName));
                              }),
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
                              
                              // Find user details for display
                              final expenseUser = allUsers.firstWhere(
                                (u) => u.id == expense.userId,
                                orElse: () => UserModel(id: '', name: 'Unknown User', email: '', role: ''),
                              );
                              final displayUserName = expenseUser.name.isNotEmpty ? expenseUser.name : expenseUser.email;

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.green.shade100,
                                  child: const Icon(Icons.attach_money, color: Colors.green),
                                ),
                                title: Text(expense.category.isNotEmpty ? expense.category : 'Uncategorized'),
                                subtitle: Text('User: $displayUserName\n${DateFormat('yMMMd').format(expense.date)} - ${expense.description}'),
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
          );
        },
      ),
    );
  }
}
