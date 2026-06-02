import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/expense_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Streams for Dashboard
  Stream<int> getTotalUsersCount() {
    return _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['role'] != 'admin';
      }).length;
    });
  }

  Stream<int> getTotalExpensesCount() {
    return _db.collectionGroup('expenses').snapshots().map((snapshot) => snapshot.docs.length);
  }

  // Get all users
  Stream<List<UserModel>> getUsers() {
    return _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .where((user) => user.role != 'admin')
          .toList();
    });
  }

  // Get all expenses
  Stream<List<ExpenseModel>> getExpenses() {
    return _db.collectionGroup('expenses').snapshots().map((snapshot) {
      final expenses = snapshot.docs
          .map((doc) => ExpenseModel.fromSnapshot(doc))
          .where((expense) => expense.userId.isNotEmpty)
          .toList();
      // Sort locally to avoid requiring a Firebase composite index
      expenses.sort((a, b) => b.date.compareTo(a.date));
      return expenses;
    });
  }

  // Delete user (Optional as per spec)
  Future<void> deleteUser(String userId) async {
    await _db.collection('users').doc(userId).delete();
    // In a real app, you might also want to delete their expenses and Firebase Auth user via Cloud Function.
  }
}
