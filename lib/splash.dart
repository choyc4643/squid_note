import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:squidgame/command_page.dart';

import 'color.dart';
import 'month_calendar.dart';
import 'package:page_transition/page_transition.dart';



class SplashScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Background,
      child: Container(
          child: AnimatedSplashScreen(
            backgroundColor: Background,
            splash: 'assets/squid3.png', duration: 1000,
            nextScreen: CommandPage(),
            splashTransition: SplashTransition.rotationTransition,
            pageTransitionType: PageTransitionType.fade,
          ),
        ),
    );
  }
}

