import 'package:cloud_firestore/cloud_firestore.dart';
import 'expense_model.dart';

class ExpenseService {
  final FirebaseFirestore _fb = FirebaseFirestore.instance;

  Future<void> addExpense(String userId, ExpenseModel expense) async {
    await _fb
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .add(expense.toJson());
  }

  // REAL-TIME STREAM (FIXED SAFETY CAST)
  Stream<List<ExpenseModel>> getExpenses(String userId) {
    return _fb
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ExpenseModel.fromJson(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  Future<void> updateExpense(
    String userId,
    String expenseId,
    ExpenseModel expense,
  ) async {
    await _fb
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(expenseId)
        .update(expense.toJson());
  }

  Future<void> deleteExpense(String userId, String expenseId) async {
    await _fb
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(expenseId)
        .delete();
  }
}