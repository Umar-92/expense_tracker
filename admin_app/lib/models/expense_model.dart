import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String id;
  final String userId;
  final double amount;
  final String category;
  final String description;
  final DateTime date;

  ExpenseModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });

  factory ExpenseModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    // Extract userId from the path (users/{userId}/expenses/{expenseId})
    final userId = doc.reference.parent.parent?.id ?? data['userId'] ?? '';
    
    // The user app uses 'title' and 'note', while the old admin model used 'description'
    final title = data['title'] ?? data['description'] ?? '';
    final note = data['note'] ?? '';
    final description = note.isNotEmpty ? '$title - $note' : title;

    return ExpenseModel(
      id: doc.id,
      userId: userId,
      amount: (data['amount'] ?? 0.0).toDouble(),
      category: data['category'] ?? '',
      description: description,
      date: data['date'] != null 
          ? (data['date'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'category': category,
      'description': description,
      'date': Timestamp.fromDate(date),
    };
  }
}
