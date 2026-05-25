
class BudgetModel {
 String id;
 String category;
 double limit;
 double spent;

 BudgetModel({
  required this.id,
  required this.category,
  required this.limit,
  required this.spent,
 });

 Map<String, dynamic> toJson(){
  return{
    'id':id,
    'category':category,
    'limit': limit,
    'spent':spent
  };
}

factory BudgetModel.fromJson(Map<String,dynamic>json){
  return BudgetModel(
    id: json['id'], 
    category: json['category'],
    limit: json['limit'], 
    spent:json['spent']
  );
}



}