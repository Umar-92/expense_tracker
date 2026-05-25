class ExpenseModel {
final String id ;
final String title;
final double amount;
final String category;
final DateTime date;

ExpenseModel({
  required this.id,
  required this.title,
  required this.amount,
  required this.category,
  required this.date,

});
Map<String, dynamic> toJson(){
  return{
    'id':id,
    'title':title,
    'amount':amount,
    'category':category,
    'date':date.toIso8601String(),

  };
}
factory ExpenseModel.fromJson(Map<String, dynamic>json){
  return ExpenseModel(
    
    id:json['id'],
    title: json['title'],
    amount: json['amount'].toDouble(),
    category: json['category'],
    date: json['date']

  );
}


}