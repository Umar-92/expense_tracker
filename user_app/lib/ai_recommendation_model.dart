

class AiRecommendationModel {

 String id;
 String message;
 DateTime createdAt;

 AiRecommendationModel({
  required this.id,
  required this.message,
  required this.createdAt,

 });

 Map<String, dynamic> toJson(){
  return{
    'id': id,
    'message':message,
    'createdAt':createdAt.toIso8601String(),
 };
}

factory AiRecommendationModel.fromJosn(Map<String, dynamic> json){
  return AiRecommendationModel(
    id: json['id'], 
    message: json['message'], 
    createdAt: json['createdAt']
    );



}


}