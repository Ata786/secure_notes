class UserModel{

  String userId;
  String userName;
  String url;
  String email;

  UserModel({required this.userId,required this.userName,required this.url,required this.email});

  factory UserModel.fromJson(Map<String,dynamic> map){
    return UserModel(
        userId: map['userId'],
        userName: map['userName'],
        url: map['url'],
        email: map['email']
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'userId': userId,
      'userName': userName,
      'url': url,
      'email': email
    };
  }



}