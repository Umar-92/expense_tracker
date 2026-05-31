import 'package:cloud_firestore/cloud_firestore.dart';
import 'budget_model.dart';

class BudgetService {
  final FirebaseFirestore _fb = FirebaseFirestore.instance;

  /// CREATE / SET BUDGET
  Future<void> setBudget(
    String userId,
    BudgetModel budget,
  ) async {
    await _fb
        .collection('users')
        .doc(userId)
        .collection('budget')
        .doc('current')
        .set(budget.toJson());
  }

  /// STREAM BUDGET (REAL-TIME UI)
  Stream<BudgetModel?> getBudget(String userId) {
    return _fb
        .collection('users')
        .doc(userId)
        .collection('budget')
        .doc('current')
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;

      return BudgetModel.fromJson(
        doc.data()!,
        doc.id,
      );
    });
  }

  /// UPDATE ONLY SPENT VALUE
  Future<void> updateSpent(
    String userId,
    double spent,
  ) async {
    await _fb
        .collection('users')
        .doc(userId)
        .collection('budget')
        .doc('current')
        .update({
      'spent': spent,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getBudgetDoc(String userId) {
  return _fb
      .collection('users')
      .doc(userId)
      .collection('budget')
      .doc('current')
      .get();
}
}