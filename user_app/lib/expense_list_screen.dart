import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';
import 'expense_provider.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() =>
      _ExpenseListScreenState();
}

class _ExpenseListScreenState
    extends State<ExpenseListScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final authProvider =
          Provider.of<AuthProvider>(
            context,
            listen: false,
          );

      final userId = authProvider.currentUser!.uid;

      Provider.of<ExpenseProvider>(
        context,
        listen: false,
      ).listenToExpenses(userId);
    });
  }

  @override
  Widget build(BuildContext context) {

    final expenseProvider =
        Provider.of<ExpenseProvider>(context);

    final expenses = expenseProvider.expenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Expenses"),
      ),

      body: expenseProvider.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : expenses.isEmpty
              ? const Center(
                  child: Text(
                    "No Expenses Found",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: expenses.length,

                  itemBuilder: (context, index) {

                    final expense = expenses[index];

                    return Card(
                      margin: const EdgeInsets.only(
                        bottom: 15,
                      ),

                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.all(15),

                        leading: CircleAvatar(
                          child: Text(
                            expense.category[0],
                          ),
                        ),

                        title: Text(
                          expense.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            const SizedBox(height: 5),

                            Text(
                              expense.category,
                            ),

                            Text(
                              expense.note,
                            ),

                            Text(
                              "${expense.date.day}/${expense.date.month}/${expense.date.year}",
                            ),
                          ],
                        ),

                        trailing: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,

                          children: [

                            Text(
                              "Rs ${expense.amount}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            IconButton(
                              onPressed: () async {

                                final authProvider =
                                    Provider.of<AuthProvider>(
                                      context,
                                      listen: false,
                                    );

                                final userId =
                                    authProvider.currentUser!.uid;

                                await Provider.of<
                                    ExpenseProvider>(
                                  context,
                                  listen: false,
                                ).deleteExpense(
                                  userId,
                                  expense.id,
                                );
                              },

                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}