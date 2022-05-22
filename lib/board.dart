import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../app.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../color.dart';


class BoardPage<T> extends StatefulWidget {

  BoardPage({Key? key}) : super(key: key);

  // final String? docID;
  // final String photo;
  // final VoidCallback onTap;
  // final double width;

  @override
  _BoardPageState createState() => _BoardPageState();
}



var firebase = FirebaseFirestore.instance;

// class DetailPage extends StatelessWidget {
class _BoardPageState extends State<BoardPage> {
  final _MenuController = TextEditingController(); //text form
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  late DocumentSnapshot variable;
 List menu = ['dinner','lunch','breakfast','night'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Modify'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
              children: [
                _showDietDialog(context),
                SizedBox(height: 45,),
              ],
        ),
      ),
    );
  }

StreamBuilder _showComment(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('comment').orderBy('timestamp', descending: true)
          .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (!snapshot.hasData)
            return const Text('Firestore snapshot is loading..');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return  ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) =>
                  Container(
                    child: Stack(children:[
                      Column(children: [
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          CircleAvatar(
                            radius: 20,
                            backgroundImage:
                            // _photoUrl(snapshot.data
                            //     ?.docs[index]['uid']),
                            NetworkImage(snapshot.data
                                  ?.docs[index]['photo']),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${snapshot.data
                                    ?.docs[index]['message']}",
                                style: TextStyle(fontSize: 10),
                                // maxLines: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Divider(
                        height: 1.0,
                        thickness: 1,
                        color: Colors.black,
                        indent: 20, // empty space to the leading edge of divider.
                        endIndent: 20, ),
                    ],),

                      Container(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/1.2),
                        child: IconButton(
                          icon:  Icon(Icons.delete),
                          onPressed: (){
                            deleteComment(snapshot.data?.docs[index].id as String);
                          }
                      ),),
                    ],
                    ),
                  ),
           );
  }
    );

}




  StatefulBuilder _showDietDialog(BuildContext context){
    return StatefulBuilder(
      builder: (context, setState) =>  Column(
        children:[
          SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:  <Widget>[
            Container(
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Background,
                          ),
                          color: Background,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                    // height: 288,
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/3.5,
                    // child: _showDietMenu(),
                    /*여기에 식단정보 들어가야함*/
                  ),
                  SizedBox(height: 10,),
                  //write 게시판 댓글
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Background,
                        ),
                        color: Background,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    height: MediaQuery.of(context).size.height/2.1,
                    width: MediaQuery.of(context).size.width,
                    // padding: EdgeInsets.symmetric(vertical: 8.0),
                    child:Column(children:[
                    _CommentInputController(),
                    //show 게시판 댓글
                    Expanded(child: _showComment(context),),

              ],),//show comment
                  ),
                  const Divider(height: 1.0),
                ],
              ),
            ),
              SizedBox(height: 30,),
            ],
          ),
        ),
            ],
      ),
    );
  }

  Widget _CommentInputController(){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Row(children:[SizedBox(width: 10,),Text('Comment'),],),
          Row(
          children:[
            SizedBox(width: 10,),
            Flexible(
              child: TextField(
                controller: _MenuController,
                onChanged: (text) {
                  setState(() {
                  });
                },
                onSubmitted: null,
                decoration:
                 InputDecoration(
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
                  icon:  Icon(Icons.message_outlined),
                  onPressed: (){
                   addComment(_MenuController.text, user!.displayName.toString(), user!.uid, 'docId');
                   _MenuController.clear();
                   }
              ),
            ),
          ],
          ),
        ],
      ),
    );
  }

  Future<void> addComment(String message, String name, String uid, String docId) async {
    FirebaseFirestore.instance.collection("comment").add({
      "message": message,
      "name": name,
      "uid": uid,
      "docId": docId,
      "timestamp":FieldValue.serverTimestamp(),
      "photo": FirebaseAuth.instance.currentUser?.photoURL,
    }).then((value) {
      FirebaseFirestore.instance.collection("comment").doc(value.id).update({"id": value.id});
    });
  }

  Future<void> deleteComment(String id) async {
    FirebaseFirestore.instance.collection("comment").doc(id).delete();
  }




  _showDietMenu(){
    return FutureBuilder(
        future: _loadMenuInfo(),
    builder: (context,  snapshot) { // <-- here
      // loadImage();
      if (!snapshot.hasData)
        return const Text('Firestore snapshot is loading..');
      //
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         for(int i=0;i<4;i++)
           if (variable[menu[i]] != null)
             Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children:[
                   Container(
                     padding: EdgeInsets.all(3),
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: i==0 ? i==2 ? i==1? Colors.green: Colors.yellow:Colors.blue:null,
                     ),
                     child: i==0 ? i==1 ? i==2? Text('아침'):Text('점심'):Text('저녁'):Text('야식'),
                   ),
                   Text(variable[menu[i]].toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                   SizedBox(height: 10),
                 ]),
        ],
      );
    },
    );
  }


  _loadMenuInfo() async {
    variable = await FirebaseFirestore.instance.
    collection('dfdf').
    doc('user1').collection('info').doc('kF8RYxy35BZXCido613P').
    get();

    return variable;
  }


}

