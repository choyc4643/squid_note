import 'package:flutter/material.dart';

import 'color.dart';
import 'textstyle.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Background,
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  SizedBox(height: 50,),
                  Image.asset(
                    'assets/squid3.png',
                    width: 180,
                  ),
                  SizedBox(height: 30,),
                  Text(
                    'Squid',
                    style: subtitlestyle(size: 30,color: Colors.white,weight: FontWeight.bold),
                  ),

                ],
              ),
              SizedBox(height: 50,),
              Text(
                'loading...',
                style: headingstyle(size: 20,color: Colors.white),
              ),
              Text(
                 'Team 11 © squid_project',
                style: headingstyle(size: 13,color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3)).then((value) {
      Navigator.pushReplacementNamed(context, '/command');
    });
  }
}
