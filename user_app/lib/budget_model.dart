class BudgetModel {
  final String id;
  final String category;
  final double limit;
  final double spent;

  BudgetModel({
    required this.id,
    required this.category,
    required this.limit,
    required this.spent,
  });

  // 🔥 Helper: remaining budget
  double get remaining => limit - spent;

  // 🔥 Helper: usage percent
  double get percentUsed =>
      limit == 0 ? 0 : (spent / limit) * 100;

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'limit': limit,
      'spent': spent,
    };
  }

  factory BudgetModel.fromJson(
    Map<String, dynamic> json,
    String id,
  ) {
    return BudgetModel(
      id: id,

      category: json['category'] ?? '',

      // 🔥 SAFE conversion (VERY IMPORTANT)
      limit: (json['limit'] ?? 0).toDouble(),

      spent: (json['spent'] ?? 0).toDouble(),
    );
  }
}