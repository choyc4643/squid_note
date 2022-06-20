import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:squidgame/textstyle.dart';
import '../app.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../color.dart';
import 'InstanceDeclare.dart';
import 'productmodel.dart';

class CommantPage<T> extends StatefulWidget {
  CommantPage({Key? key}) : super(key: key);

  // final String? docID;
  // final String photo;
  // final VoidCallback onTap;
  // final double width;

  @override
  _CommantPageState createState() => _CommantPageState();
}

var firebase = FirebaseFirestore.instance;

// class DetailPage extends StatelessWidget {
class _CommantPageState extends State<CommantPage> {
  final _MenuController = TextEditingController(); //text form
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  late DocumentSnapshot variable;
  List menu = ['dinner', 'lunch', 'breakfast', 'night'];

  @override
  Widget build(BuildContext context) {
    List<food>? docData =
        ModalRoute.of(context)!.settings.arguments as List<food>?;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Primary,
        actions: [
          IconButton(
                onPressed: () {
                  // Navigator.pushNamed(context, '/mapreceipt');
                  Navigator.pushNamed(context, '/mapreceipt',arguments: docData!
                      .map((e) => e.day)
                      .toString()
                      .replaceAll('(', '')
                      .replaceAll(')', ''));
                },
                icon: Icon(Icons.map_outlined)),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/adddiet',
                    arguments: docData!
                        .map((e) => e.day)
                        .toString()
                        .replaceAll('(', '')
                        .replaceAll(')', ''));
                print('update pushed');
              },
              icon: Icon(Icons.update)),
          IconButton(
              onPressed: () {
                deleteMeal(docData!
                    .map((e) => e.id)
                    .toString()
                    .replaceAll('(', '')
                    .replaceAll(')', ''));
                print(docData
                    .map((e) => e.id)
                    .toString()
                    .replaceAll('(', '')
                    .replaceAll(')', ''));
                Navigator.pop(context);
              },
              icon: Icon(Icons.delete)),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            // print(docData!.map((e) => e.id).toString());
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Detail',style: headingstyle(size:18.0,color: Colors.black87)),
        centerTitle: true,
      ),
      backgroundColor: Background,
      body: SingleChildScrollView(child: _showDietDialog(context)),
    );
  }

  StreamBuilder _showComment(BuildContext context, String docId) {
    // String docId2 = ModalRoute.of(context)!.settings.arguments as String;
    List<food>? docData =
        ModalRoute.of(context)!.settings.arguments as List<food>?;

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('comment')
            // .orderBy('timestamp', descending: true)
            .where("docId", isEqualTo: docData!.map((e) => e.id).toString())
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return const Text('Firestore snapshot is loading..');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) => Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  // _photoUrl(snapshot.data
                                  //     ?.docs[index]['uid']),
                                  NetworkImage(
                                      snapshot.data?.docs[index]['photo']),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${snapshot.data?.docs[index]['message']}",
                                  style: subtitlestyle(size: 13),
                                  // maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 1.0,
                          thickness: 1,
                          color: Colors.black,
                          indent:
                              20, // empty space to the leading edge of divider.
                          endIndent: 60,
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 1.2),
                      child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteComment(
                                snapshot.data?.docs[index].id as String);
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  StatefulBuilder _showDietDialog(BuildContext context) {
    // String docId = ModalRoute.of(context)!.settings.arguments as String;
    List<food>? docData =
        ModalRoute.of(context)!.settings.arguments as List<food>?;

    return StatefulBuilder(
      builder: (context, setState) => Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: mealCol()),
                SizedBox(
                  height: 10,
                ),
                const Divider(
                  height: 1.0,
                  thickness: 1,
                  endIndent: 20,
                  indent: 20,
                  color: Colors.black,
                ),
                mapStream(docData!.map((e) => e.day).toString().replaceAll('(', '').replaceAll(')', ''), docData.map((e) => e.uid).toString().replaceAll('(', '').replaceAll(')', '')),
                //write 게시판 댓글
                _CommentInputController(),
                //show 게시판 댓글
                _showComment(context, docData.map((e) => e.id).toString()),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ],
      ),
    );
  }

StreamBuilder<DocumentSnapshot> mapStream(String selday, String user) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('menu').doc(user+selday).collection('maprecipe').doc(user+selday).snapshots(),
      builder: (BuildContext context, snapshot) {
        if(snapshot.hasData){
          if (snapshot.data!.exists) {
          return Container(
              // height: MediaQuery.of(context).size.height/1.5,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    width: 400,
                    child: Text(
                      "주소 : "+snapshot.data!.get("location")
                      , style: subtitlestyle(size: 20),),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    width: 400,
                    child: Text(
                            "식당 이름 : "+snapshot.data!.get("storeName")
                            , style: subtitlestyle(size: 20),),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    width: 400,
                    child: Text(
                            "한줄 평: "+snapshot.data!.get("storComment")
                            , style: subtitlestyle(size: 20),),
                  ),

                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            "영수증: "
                            , style: subtitlestyle(size: 20),),
                          IconButton(
                            icon: Icon(Icons.receipt_long_outlined), onPressed: () =>  FlutterDialog(snapshot.data!.get("receipt")),),
                        ],
                      ),
                    ],
                  ),
                  const Divider(
                  height: 1.0,
                  thickness: 1,
                  endIndent: 20,
                  indent: 20,
                  color: Colors.black,
                ),

                ],
              )
            );
        } else
          return 
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text("등록된 위치 정보가 없습니다."),
              ),
              const Divider(
                  height: 1.0,
                  thickness: 1,
                  endIndent: 20,
                  indent: 20,
                  color: Colors.black,
                ),
            ],
          );
        }
        else return
          CircularProgressIndicator();

        },

    );

  }


  Widget _CommentInputController() {
    // String docId = ModalRoute.of(context)!.settings.arguments as String;
    List<food>? docData =
        ModalRoute.of(context)!.settings.arguments as List<food>?;

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Comment',
                  style: subtitlestyle(size: 20),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: TextField(
                    controller: _MenuController,
                    onChanged: (text) {
                      setState(() {});
                    },
                    onSubmitted: null,
                    decoration: InputDecoration(
                      // hintText: 'Send a message',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    // focusNode: _focusNode,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                      icon: Icon(Icons.message_outlined),
                      onPressed: () {
                        addComment(
                            _MenuController.text,
                            user!.displayName.toString(),
                            user!.uid,
                            docData!.map((e) => e.id).toString());
                        _MenuController.clear();
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addComment(
      String message, String name, String uid, String docId) async {
    FirebaseFirestore.instance.collection("comment").add({
      "message": message,
      "name": name,
      "uid": uid,
      "docId": docId,
      "timestamp": FieldValue.serverTimestamp(),
      "photo": FirebaseAuth.instance.currentUser?.photoURL,
    }).then((value) {
      FirebaseFirestore.instance
          .collection("comment")
          .doc(value.id)
          .update({"id": value.id});
    });
  }

  Future<void> deleteComment(String id) async {
    FirebaseFirestore.instance.collection("comment").doc(id).delete();
  }

  Future<void> deleteMeal(String id) async {
    FirebaseFirestore.instance.collection("menu").doc(id).delete();
  }

  Column mealCol() {
    List<food>? docData =
        ModalRoute.of(context)!.settings.arguments as List<food>?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/sunrise.png",
                  width: 24,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: Morning
                  ),
                  child: Text(
                    '아침',
                    style: subtitlestyle(size: 20),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                child: Text(
                  docData!
                      .map((e) => e.breakfast)
                      .toString()
                      .replaceAll('(', '')
                      .replaceAll(')', ''),
                  style: subtitlestyle(size: 20),
                  maxLines: 5,
                ),
              ),
            ),
          ],
        ),
        Divider(
          thickness: 1, height: 30,
        ),

       Row(
          children: [
            Column(
              children: [
                Icon(Icons.wb_sunny_outlined),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: Morning
                  ),
                  child: Text(
                    '점심',
                    style: subtitlestyle(size: 20),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                child: Text(
                  docData
                      .map((e) => e.launch)
                      .toString()
                      .replaceAll('(', '')
                      .replaceAll(')', ''),
                  style: subtitlestyle(size: 20),
                  maxLines: 5,
                ),
              ),
            ),
          ],
        ),
        Divider(
          thickness: 1, height: 30,
        ),

        Row(
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/sunset.png",
                  width: 24,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: Morning
                  ),
                  child: Text(
                    '저녁',
                    style: subtitlestyle(size: 20),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                child: Text(
                  docData
                      .map((e) => e.dinner)
                      .toString()
                      .replaceAll('(', '')
                      .replaceAll(')', ''),
                  style: subtitlestyle(size: 20),
                  maxLines: 5,
                ),
              ),
            ),
          ],
        ),
        Divider(
          thickness: 1,height: 30,
        ),
        Row(
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/night.png",
                  width: 24,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: Morning
                  ),
                  child: Text(
                    '야식',
                    style: subtitlestyle(size: 20),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                child: Text(
                  docData
                      .map((e) => e.late_meal)
                      .toString()
                      .replaceAll('(', '')
                      .replaceAll(')', ''),
                  style: subtitlestyle(size: 20),
                  maxLines: 5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  void FlutterDialog(String data) {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("Receipt"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data,
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
