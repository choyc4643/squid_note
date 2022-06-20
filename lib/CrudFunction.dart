import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:squidgame/productmodel.dart';
var firebase = FirebaseFirestore.instance;
var firebaseAuth = FirebaseAuth.instance;

class CrudFunction {
  var userRef = firebase.collection("user");
  var eventRef = firebase.collection("menu");
  var chatRef = firebase.collection("chatroom");
  var userRef2 = firebase.collection("user").where("FriendsUidList",arrayContains: firebaseAuth.currentUser!.uid);

  Future<void> addNewFriend(String friendUid) async{
    print("ss");
    userRef.doc(firebaseAuth.currentUser!.uid).update(
        {
          "FriendsUidList" : FieldValue.arrayUnion([friendUid]),
        }
    );
  }
  Future<void> addevent( String uid, String breakfast, String launch,
      String dinner,String late_meal,String name, String is_school, String day) async {
    eventRef.add({
      "uid": uid,
      "breakfast": breakfast,
      "launch": launch,
      "dinner": dinner,
      "late_meal": [],
      "name": name,
      //FieldValue.serverTimestamp(),
      "is_school":is_school,
      "day" : day
    }).then((value) {
      eventRef.doc(value.id).update({"id": value.id});
    });
  }

  Stream<List<food>> eventstream() {
    return eventRef.snapshots().map((value) => value.docs
        .map((element) => food(
      uid: element.data()["uid"],
      breakfast: element.data()["breakfast"],
      launch: element.data()["launch"],
      dinner: element.data()["dinner"],
      late_meal: element.data()["late_meal"],
      name: element.data()["name"],
      // is_school: element.data()["is_school"],
      day:element.data()["day"],
      id: element.data()["id"]
    )
    )
        .toList());
  }
    Stream<List<food>> eventstream2(String day) {
    return eventRef.snapshots().map((value) => value.docs
    .where((element) => element.data()["day"] == day)
    .where((element) => element.data()["uid"] == firebaseAuth.currentUser!.uid)
        .map((element) => food(
      uid: element.data()["uid"],
      breakfast: element.data()["breakfast"],
      launch: element.data()["launch"],
      dinner: element.data()["dinner"],
      late_meal: element.data()["late_meal"],
      name: element.data()["name"],
      // is_school: element.data()["is_school"],
      day:element.data()["day"],
      id: element.data()["id"]
    )
    )
        .toList());
  }


     Stream<List<food>> eventstream3(String user) {
    return eventRef.snapshots().map((value) => value.docs
    .where((element) => element.data()["uid"] == user)
        .map((element) => food(
      uid: element.data()["uid"],
      breakfast: element.data()["breakfast"],
      launch: element.data()["launch"],
      dinner: element.data()["dinner"],
      late_meal: element.data()["late_meal"],
      name: element.data()["name"],
      // is_school: element.data()["is_school"],
      day:element.data()["day"],
      id: element.data()["id"]
    )
    )
        .toList());
  }

Future<void> addMapMarker( String uid, String storeName,String storeComment, int active, String location,String day) async {
    String documentId = uid+day;
    eventRef.doc(documentId.toString()).set({
      "storeName": storeName,
      "storeComment": storeComment,
      "active": active,
      "location": location,
      "timestamp": FieldValue.serverTimestamp(),
      "docid":documentId,
      "id":documentId,

    });
  }


  Future<void> addGoogleUser(String email, String name, String uid, String userphoto) async {
    userRef.doc(uid).set({
      "email": email,
      "name": name,
      "uid": uid,
      "FriendsUidList": [],
      "userphoto":userphoto,
      "id" : "id",
    });
  }



  Stream<List<user>> userStream() {
    return userRef.snapshots().map((value) => value.docs
        .map((element) => user(
      name: element.data()['name'],
      uid: element.data()["uid"],
      email: element.data()["email"],
      FriendsUidList: element.data()["FriendsUidList"],
      userphoto: element.data()["userphoto"],
    )
    )
        .toList());
  }

  List<Future<user>>getMyFriends(List friendsList){
    return friendsList.map((e) async{
      var a = await userRef.doc(e).get();
      return user(
        email: a["email"],
        name:  a["name"],
        uid:  a["uid"],
        FriendsUidList:  a["FriendsUidList"],
        userphoto: a["userphoto"],
      );
    }
    ).toList();
  }

  Future<void> addChatroom( String uid, String name, int active, String token, String channelName,String chatRoomName) async {
    chatRef.add({
      "uid": uid,
      "name": name,
      "active": active,
      "token": token,
      "channelName": channelName, //channel_name = uid, 1 person can make 1 room
      "chatRoomName": chatRoomName,
      "timestamp": FieldValue.serverTimestamp(),
    }).then((value) {
      chatRef.doc(value.id).update({"id": value.id});
    });
  }

  Stream<DocumentSnapshot> streamMyUserModel(String uid){
    return userRef.doc(uid).snapshots();
  }

  Future<void> updateChatroom(String uid, String id, String token) async {
    chatRef.doc(id).update({
      "token": token,
    });
  }

  Stream<List<room>> roomStream() {
    return chatRef.snapshots().map((value) => value.docs
        // .where((element) => element.data()["active"] == '1')
        .map((element) => room(
      user_name: element.data()['name'],
      uid: element.data()["uid"],
      active: element.data()["active"],
      id: element.data()["id"],
      channelName: element.data()["channelName"],
      chatRoomName: element.data()["chatRoomName"],
      token: element.data()["token"],
    )
    )
        .toList());
  }

}
