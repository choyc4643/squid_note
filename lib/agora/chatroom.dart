import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:squidgame/InstanceDeclare.dart';

import 'package:squidgame/textstyle.dart';

import '../color.dart';
import '../login.dart';
import '../productmodel.dart';
import './call.dart';


class ChatRoomPage extends StatefulWidget {
  final List<String> list = List.generate(16, (index) => "Text $index");
  @override
  State<StatefulWidget> createState() => ChatRoomPageState();
}

var firebaseAuth = FirebaseAuth.instance;

class ChatRoomPageState extends State<ChatRoomPage> {
  /// create a channelController to retrieve text value

 Future<void> deleteChatroom(String id) async {
    FirebaseFirestore.instance.collection("chatroom").doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      appBar: AppBar(
        backgroundColor: Primary,
        leading: Container(),
        title: Text('Chatroom',style: headingstyle(color: Colors.black,)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            roomsStream(),
          ],
        ),
        // child: Card(
        //   clipBehavior: Clip.antiAlias,
        //   child: oneRoom(),
        // ),
      ),
      floatingActionButton: _createFloatingActionButton(context),
    );
  }

  @override
  Widget _createFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: SubPrimary,
      elevation: 8.0,
      child: Icon(Icons.add, color: Colors.white),
      onPressed: () {
        Navigator.pushNamed(context, '/index',);
      },
    );
  }




  StreamBuilder<List<room>>  roomsStream() {
    return StreamBuilder<List<room>>(
      stream: crudFunction.roomStream(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length>0) {
            var productList = snapshot.data!;
            return ListView(
                shrinkWrap: true,
                children: [
                   Container(
                    child: ListView.builder(
                      // crossAxisCount: 1,
                      padding: const EdgeInsets.all(5),
                      // childAspectRatio: 8.0 / 11.0,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: productList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                            child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 200,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(productList[index].chatRoomName,style: headingstyle(size:20,),),
                                      SizedBox(height: 10),
                                      Text(productList[index].user_name,style: subtitlestyle(size:17,)),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Expanded(
                                  child:
                                  IconButton(
                                    onPressed: (){
                                      onJoin(productList[index].channelName, productList[index].token);
                                    },
                                    icon: Icon(Icons.door_back_door_outlined, size: 35,),
                                  ),
                                ),
                                SizedBox(width: 20,),
                                IconButton(
                                    onPressed: (){
                                      if(productList[index].uid == firebaseAuth.currentUser!.uid.toString())
                                        deleteChatroom(productList[index].id);
                                      else print('failed to delete');
                                    },
                                    icon: Icon(Icons.delete, size: 35,),
                                  ),
                              ],
                            ),),
                        );
                      },
                      // physics: NeverScrollableScrollPhysics(),
                      // children: _buildListCards(context, productList,),
                    ),
                  ),
                ]
                );
          } else {
            return
              Container(
                  margin: EdgeInsets.only(top: 300),
                  child: Center(
                    child: Text(
                      '아직 만들어진 채팅방이 없습니다.',style: subtitlestyle(size: 20),),
                  ));

          }
        }
        else return CircularProgressIndicator();
      },
    );
  }



  //builder에 return 해줄 각각의 room
  oneRoom(){
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("ChannelName",style: headingstyle(size:20,),),
                SizedBox(height: 10),
                Text("personName",style: subtitlestyle(size:17,)),
              ],
            ),
            // SizedBox(
            //   width: 20,
            // ),
            Expanded(
              child:
                IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.door_back_door_outlined, size: 35,),
                ),
            ),
          ],
        ),),
    );
  }

  List<Container> _buildListCards(BuildContext context, List<room> roomlist) {
    //List<Product> products = ProductsRepository.loadProducts(Category.all);
    List<room> products = roomlist;
    if (products.isEmpty) {
      print('empty');
      return const <Container>[];
    }

    // final ThemeData theme = Theme.of(context);
    // final NumberFormat formatter = NumberFormat.simpleCurrency(
    //     locale: Localizations.localeOf(context).toString());

    return products.map((room) {
      return
        Container(
          height: 20,
            width: 20,
            child:
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("${room.chatRoomName}",style: headingstyle(size:20,),),
                      SizedBox(height: 10),
                      Text("${room.user_name}",style: subtitlestyle(size:17,)),
                    ],
                  ),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  Expanded(
                    child:
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.door_back_door_outlined, size: 35,),
                    ),
                  ),
                ],
              ),),
        );
    }).toList();
  }



  Future<void> onJoin(String channelName, String token) async {
    // update input validation
    setState(() {

    });

      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);


      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: channelName,
            token: token,
          ),
        ),
      );

  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}