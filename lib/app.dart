import 'package:flutter/material.dart';
import 'color.dart';
import 'month_calendar.dart';
import 'login.dart';
// import 'mypage.dart';


class SquidApp extends StatelessWidget {
  const SquidApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Squid',
      home: LoginPage(),
      theme: ThemeData(
        primaryColor: Primary,
      ),
      initialRoute: '/',
      routes: {
        '/login': (context) => LoginPage(),
        '/month_calendar' : (context) => MonthCalendar(),
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