//

import 'dart:async';
// import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import '../color.dart';
import './setting.dart';
import './user.dart';

class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String? token;
  final String? channelName;

  const CallPage({Key? key, this.token, this.channelName}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late RtcEngine _engine;
  Map<int, User> _userMap = new Map<int, User>();
  bool _muted = false;
  int? _localUid;
  // String baseUrl = 'https://agoraserverforsquidfinal.herokuapp.com';
  // late String token;
  int uid = 0;

  @override
  void dispose() {
    //clear users
    _userMap.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      print("'APP_ID missing, please provide your APP_ID in settings.dart");
      return;
    }
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // await getToken();
    await _engine.joinChannel(widget.token, widget.channelName ?? "", null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.Communication);
    // Enables the audioVolumeIndication
    await _engine.enableAudioVolumeIndication(250, 3, true);
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(
      RtcEngineEventHandler(error: (code) {
        print("error occurred $code");
      }, joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          _localUid = uid;
          _userMap.addAll({uid: User(uid, false)});
        });
      }, leaveChannel: (stats) {
        setState(() {
          _userMap.clear();
        });
      }, userJoined: (uid, elapsed) {
        setState(() {
          _userMap.addAll({uid: User(uid, false)});
        });
      }, userOffline: (uid, elapsed) {
        setState(() {
          _userMap.remove(uid);
        });
      },
          // tokenPrivilegeWillExpire: (token) async {
          //     await getToken();
          //     await _engine.renewToken(token);
          //   },
          /// Detecting active speaker by using audioVolumeIndication callback
          audioVolumeIndication: (volumeInfo, v) {
            volumeInfo.forEach((speaker) {
              //detecting speaking person whose volume more than 5
              if (speaker.volume > 5) {
                try {
                  _userMap.forEach((key, value) {
                    //Highlighting local user
                    //In this callback, the local user is represented by an uid of 0.
                    if ((_localUid?.compareTo(key) == 0) && (speaker.uid == 0)) {
                      setState(() {
                        _userMap.update(key, (value) => User(key, true));
                      });
                    }

                    //Highlighting remote user
                    else if (key.compareTo(speaker.uid) == 0) {
                      setState(() {
                        _userMap.update(key, (value) => User(key, true));
                      });
                    } else {
                      setState(() {
                        _userMap.update(key, (value) => User(key, false));
                      });
                    }
                  });
                } catch (error) {
                  print('Error:${error.toString()}');
                }
              }
            });
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      appBar: AppBar(
        title: Text("Group call"),
        backgroundColor: Primary,
      ),
      body: Stack(
        children: [_buildGridVideoView(), _toolbar()],
      ),
    );
  }

  GridView _buildGridVideoView() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: _userMap.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: MediaQuery.of(context).size.height / 1100,
          crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Container(
              color: Colors.white,
              child: (_userMap.entries.elementAt(index).key == _localUid)
                  ? RtcLocalView.SurfaceView()
                  : RtcRemoteView.SurfaceView(
                  uid: _userMap.entries.elementAt(index).key)),
          decoration: BoxDecoration(
            border: Border.all(
                color: _userMap.entries.elementAt(index).value.isSpeaking
                    ? Colors.blue
                    : Colors.grey,
                width: 6),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              _muted ? Icons.mic_off : Icons.mic,
              color: _muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: _muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pushNamed(context,'/chatroom');
  }

  void _onToggleMute() {
    setState(() {
      _muted = !_muted;
    });
    _engine.muteLocalAudioStream(_muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  //Todo
  // Future<void> getToken() async {
  //   final response = await http.get(
  //     Uri.parse(baseUrl +
  //         '/rtc/' +
  //         widget.channelName! +
  //         '/publisher/uid/' +
  //         uid.toString()
  //       // To add expiry time uncomment the below given line with the time in seconds
  //       // + '?expiry=45'
  //     ),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       token = response.body;
  //       token = jsonDecode(token)['rtcToken'];
  //
  //     });
  //   } else {
  //     print('Failed to fetch the token');
  //   }
  //   print('token is blabla'+token);
  // }
}