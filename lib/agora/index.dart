import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:squidgame/textstyle.dart';

import '../InstanceDeclare.dart';
import '../color.dart';
import './call.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();

  /// if channel textField is validated to have error
  bool _validateError = false;

  String baseUrl = 'https://agoraserverforsquidfinal.herokuapp.com';
  late String token;
  // late String channelName;

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      appBar: AppBar(
        backgroundColor: Primary,
        centerTitle: true,
        title: Text('Agora Flutter video Call',style: headingstyle(),),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: _channelController,
                  decoration: InputDecoration(
                    errorText:
                        _validateError ? 'Channel name is mandatory' : null,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
                    hintText: 'Channel name',
                    hintStyle: subtitlestyle()
                  ),
                ))
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(SubPrimary),
                  ),
                  onPressed: onJoin,
                  child: Text('Join', style: subtitlestyle(),),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // String uid = firebaseAuth.currentUser!.uid!;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String channelName = FirebaseAuth.instance.currentUser!.uid;
  // String name= firebaseAuth.currentUser!.displayName!;
  String user_name = FirebaseAuth.instance.currentUser!.displayName!;

  //create chatroom
  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await getToken();
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);

      crudFunction.addChatroom(
          uid, user_name, 1, token, uid, _channelController.text);
      Navigator.pop(context);
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            token: token,
            channelName: uid,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  //generate token for call
  Future<void> getToken() async {
    final response = await http.get(
      Uri.parse(baseUrl + '/rtc/' + channelName + '/publisher/uid/' + '0'
          // To add expiry time uncomment the below given line with the time in seconds
          // + '?expiry=45'
          ),
    );

    if (response.statusCode == 200) {
      setState(() {
        token = response.body;
        token = jsonDecode(token)['rtcToken'];
      });
    } else {
      print('Failed to fetch the token');
    }
  }
}
