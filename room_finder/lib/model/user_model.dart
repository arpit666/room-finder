
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  late final String userFullName;
  late final String userEmail;
  late final String userPhone;
  late final String about;
  late final String pushToken;
  late final String userId;

  late final String image;

  late final List favRooms;
  late final List chatIds;
  UserModel({required this.userFullName,required this.userId,
    required this.userEmail,required this.chatIds,
    required this.image,required this.userPhone,required this.about,required this.pushToken});



  UserModel.fromJson(Map<String,dynamic> json){
    image = json['profile_picture'] ?? '';
    about = json['about'] ?? '';
    userId = json['userId'] ?? '';
    userEmail = json['email'] ?? '';
    userPhone = json['phone'] ?? '';
    favRooms = json['favoriteRooms'] ?? [];
    userFullName = json['name'] ?? '';
    pushToken =  json['pushToken'] ?? '';
    chatIds = json['chatIds'] ?? [];

  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['profile_picture'] = image ;
    data['about'] = about ?? '';
    data['name'] = userFullName ?? '';
    data['userId'] = userId ?? '';
    data['email'] = userEmail ?? '';
    data['pushToken'] = pushToken ?? '';
    data['favoriteRooms'] = favRooms ?? '';
    data['phone'] = userPhone ?? '';
    data['chatIds'] = chatIds;

    return data;
  }
}

