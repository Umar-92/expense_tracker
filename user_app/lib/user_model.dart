class UserModel {

String uid;
String name;
String email;

UserModel({
 required this.uid,
 required this.name,
 required this.email

});

Map<String, dynamic> toJson(){
return {
  'id':uid,
  'name':name,
  'email':email
};
}

factory UserModel.fromJson(Map<String,dynamic> json){

return UserModel(
  uid:json['uid'],
  name: json['name'],
  email: json['email'],
);
}


}