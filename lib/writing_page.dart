import 'package:flutter/material.dart';
import 'color.dart';

class WritingPage extends StatefulWidget {
  const WritingPage({ Key? key }) : super(key: key);

  @override
  State<WritingPage> createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      body: Column(
        children: [
          SizedBox(height: 20,),
          Row(children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),
            Center(child: Text('data'))
          ],)
      ],),
    );
  }
}