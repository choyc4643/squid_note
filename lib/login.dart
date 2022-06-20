
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
//
// import 'app.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const SquidApp());
// }

// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:squidgame/textstyle.dart';
import 'color.dart';
import 'package:squidgame/CrudFunction.dart';
import 'InstanceDeclare.dart';
String uid = "";
String uid_google = "";
String name_user = "";
String email_user = "";
String url_user = "";
var firebaseAuth = FirebaseAuth.instance;
Future<UserCredential> signInWithAnonynous() async {
  return FirebaseAuth.instance.signInAnonymously();
}

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser =
  await GoogleSignIn(scopes: ['profile', 'email']).signIn();
  final GoogleSignInAuthentication? googleAuth =
  await googleUser?.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class LoginPage extends StatefulWidget {
   const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _flag = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      body: SafeArea(
        child: Column(
          children: <Widget>[
        Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(90)),
            color:  Color(0xFF8A8D80),
            gradient: LinearGradient(colors: [(new  Color(0xFF8A8D80)),  Color(0xFFB0B4A2)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),

        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Image.asset(
                    "assets/squid4.png",
                    height: 90,
                    width: 90,
                  ),
                ),
                //<a href="https://www.flaticon.com/kr/free-icons/" title="오징어 아이콘">오징어 아이콘  제작자: Freepik - Flaticon</a>
                Container(
                  margin: EdgeInsets.only(right: 20, top: 20),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Squid',
                    style: subtitlestyle(size: 30,color: Colors.white,weight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20, top: 0),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '나만의 식단 기록어플',
                    style: subtitlestyle(size: 15,color: Colors.white),
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(right: 20, top: 20),
                //   alignment: Alignment.bottomRight,
                //   child: Text(
                //     "Login",
                //     style: TextStyle(
                //         fontSize: 20,
                //         color: Colors.white
                //     ),
                //   ),
                // )
              ],
            )
        ),
        ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 10.0),
            //   child: Column(
            //     children: const <Widget>[
            //       // Image.asset('assets/logo.png'),
            //       Text('Squid'),
            //       SizedBox(height: 80.0),
            //
            //       SizedBox(height: 30.0),
            //     ],
            //   ),
            // ),
            //const SizedBox(height: 10.0),
            SizedBox(height: 140,),
            Padding(
              padding: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 50.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Button, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () async {
                          signInWithGoogle().then((value) {
                            crudFunction.addGoogleUser(
                              firebaseAuth.currentUser!.email!,
                              firebaseAuth.currentUser!.displayName!,
                              firebaseAuth.currentUser!.uid,
                              firebaseAuth.currentUser!.photoURL!,
                            );
                            Navigator.pushNamed(
                              context,
                              '/sp',
                            );

                          });
                          setState(() => _flag = !_flag);
                        },
                        child: Text('Google Login',
                          style: subtitlestyle(size: 20,color: Colors.white),
                        ),
                      ),
                    //  // /*
                    //   ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       primary: Button, // background
                    //       onPrimary: Colors.white, // foreground
                    //     ),
                    //     onPressed: () async {
                    //         Navigator.pushNamed(
                    //           context,
                    //           '/sp',
                    //         );
                    //     },
                    //     child: Text('splash',
                    //       style: subtitlestyle(size: 20,color: Colors.white),
                    //     ),
                    //   ),
                    //   //*/
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
