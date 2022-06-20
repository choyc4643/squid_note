import 'package:flutter/material.dart';
import 'package:squidgame/TfliteModel.dart';
import 'package:squidgame/agora/call.dart';
import 'package:squidgame/agora/chatroom.dart';
import 'package:squidgame/command_page.dart';
import 'package:squidgame/youtube_page.dart';
import 'FriendsDetail.dart';
import 'add_map_recipe.dart';
import 'agora/index.dart';
import 'color.dart';
import 'month_calendar.dart';
import 'login.dart';
// import 'mypage.dart';
import 'SearchFriends.dart';
import 'commant.dart';
import 'adddiet.dart';
import 'agora/call.dart';
import 'agora/chatroom.dart';
import 'receipt.dart';
import 'splash.dart';
import 'splash_screen.dart';
class SquidApp extends StatelessWidget {
  const SquidApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Squid',
            debugShowCheckedModeBanner: false,

      home: MonthCalendar(),
      theme: ThemeData(
        primaryColor: Primary,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/month_calendar' : (context) => MonthCalendar(),
        '/SearchFriends' : (context) => SearchFreinds(),
        '/commant' : (context) => CommantPage(),
        '/adddiet' : (context) => AddDiet(),
        '/command' : (context) => CommandPage(),
        '/index' : (context) => IndexPage(),
        '/chatroom' : (context) => ChatRoomPage(),
        '/call' : (context) => CallPage(),
        '/receipt' : (context) => MyHomePage(),
        '/youtube':(context) => YoutubePage(),
        '/imagecl' :(context) => TfliteModel(),
        '/mapreceipt' :(context) => SaveMap(),
        '/friendsdetail' :(context) => FriendsDetail(),
        '/sp': (context) => SplashScreen(),

        //'/maptest' : (context) => MapPage(),

        // '/mypage' : (context) => const MyPage (),

      },
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }
}
