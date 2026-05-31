import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String note;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });

  // SAVE TO FIRESTORE
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'note': note,

      // 🔥 IMPORTANT FIX
      'date': Timestamp.fromDate(date),
    };
  }

  // READ FROM FIRESTORE
  factory ExpenseModel.fromJson(
    Map<String, dynamic> json,
    String id,
  ) {
    return ExpenseModel(
      id: id,
      title: json['title'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      note: json['note'] ?? '',

      // 🔥 FIX: Timestamp → DateTime
      date: (json['date'] as Timestamp).toDate(),
    );
  }
}