import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';



class user{
  user({
    required this.name,
    required this.uid,
    required this.email,
    required this.FriendsUidList,
    required this.userphoto,

  });

  String name;
  String uid;
  String email;
  List FriendsUidList;
  String userphoto;

}

class food{
  food({
    required this.uid,
    required this.breakfast,
    required this.dinner,
    required this.launch,
    required this.late_meal,
    required this.name,
    // required this.is_school,
    required this.day,
    required this.id

  });

  final String uid;
  final String breakfast;
  final String launch;
  final String dinner;
  final String late_meal;
  final String name;
  // final bool is_school;
  final String day;
  final String id;
}

class room{
  room({
    required this.user_name,
    required this.uid,
    required this.channelName,
    required this.chatRoomName,
    required this.token,
    required this.active,
    required this.id,
  });

  String user_name;
  String uid;
  String channelName;
  String chatRoomName;
  String token;
  int active;
  String id;
}

class mapRecipe{
  mapRecipe({
    required this.storeName,
    required this.storeComment,
    required this.active,
    required this.location,
    required this.timestamp,
    required this.docId,
    required this.id,

  });

  String storeName;
  String storeComment;
  String active;
  String location;
  String timestamp;
  String docId;
  String id;


}
