// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:squidgame/textstyle.dart';
import 'package:table_calendar/table_calendar.dart';
import '../color.dart';
import '../utils.dart';
import '../color.dart';
import '../textstyle.dart';
// import 'detail_page.dart';
import 'month_calendar.dart';

class AddDiet extends StatefulWidget {
  // AddDiet ({ Key? key, required final String? selectDay }): _selectDay = selectDay, super(key: key);
  // String? _selectDay;

  @override
  _AddDietState createState() => _AddDietState();
}

class _AddDietState extends State<AddDiet> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  bool is_social=true;


  final _breakfastController = TextEditingController(); //text form
  final _lunchController = TextEditingController(); //text form
  final _dinnerController = TextEditingController(); //text form
  final _latemealController = TextEditingController(); //text form
  final _formKey = GlobalKey<FormState>();
  final RegExp _regExp = RegExp(r'[\uac00-\ud7af]', unicode: true);



  get floatingActionButton => null;

  final List<String> _valueList = ['아침', '점심','저녁','야식'];
  String _selectedValue = '아침';
  //checkbox
  List<bool> _isChecked = [false,false,false];
  List<String> _isCheckedName = ['음주','학식','외식'];
  String? _dietTDay;
  Map<String, bool> values = {
    '음주': true,
    '학식': false,
    '외식': false,
  };

  User? user = FirebaseAuth.instance.currentUser;

  dynamic picStr;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
     return Scaffold(
       backgroundColor: Background,
       resizeToAvoidBottomInset: false,
       appBar: AppBar(
         backgroundColor: Primary,
         leading: IconButton(
           onPressed: () {
             Navigator.pop(context);
           },
           icon: Icon(Icons.arrow_back),
         ),
         title: Text("Writing Page",style: headingstyle(size:18.0,color: Colors.black87)),
         centerTitle: true,
       ),
       body: Container(
      child: _MenuDiet(context),
      ),
    );
  }


  Widget _MenuDiet(BuildContext context){
        String day = ModalRoute.of(context)?.settings.arguments as String;

    // return SingleChildScrollView(
    //       child:
          return Column(
            mainAxisSize: MainAxisSize.min,
            children:  <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text('${user!.displayName}의  ${day.replaceAll('00:00:00.000Z', '')}식단',style: subtitlestyle(size:18.0,color: Colors.black),)),
              //  Row(
              //    mainAxisAlignment: MainAxisAlignment.end,
              //    children: [
              //   IconButton(onPressed: (){ Navigator.pushNamed(context, '/receipt');}, icon: Icon(Icons.list_alt_rounded)),
              //   SizedBox(width: 10,),

              // ],),
              SizedBox(height: 10,),
              Expanded(
                child: Column(
                // height: 288,
                // width: 245,
                // padding: EdgeInsets.symmetric(vertical: 8.0),
                // color: Background,
                children: [
                  _MenuInputController(),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(SubPrimary),
                  ),
                    onPressed: () => {
                      if (_formKey.currentState!.validate()){
                        // addevent
                        addMeal
                        (
                            user!.uid.toString(),
                            _breakfastController.text.toString(),
                            _lunchController.text.toString(),
                            _dinnerController.text,
                            _latemealController.text,
                            user!.displayName.toString(),
                            day
                        ),
                        _breakfastController.clear(),
                        _lunchController.clear(),
                        _dinnerController.clear(),
                        _latemealController.clear(),
                        Navigator.pop(context),
                      }
                    },
                    child: Text('완료', style: subtitlestyle(color: Colors.black),),
                  ),
                ],),
              ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [

              // FlatButton(
              //   textColor: TextSmall,
              //   onPressed: () => {
              //     Navigator.pushNamed(context, '/board'),
              //   },
              //   child: Text('게시판'),
              // ),
          //   ],
          // ),

            ],
          );
    // );//
  }

  Widget _MenuInputController(){
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.fromLTRB(30,10,10,30),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              children: [
                Container(
                  width: 300,
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    controller: _breakfastController,
                    autofocus: false,
                    maxLines:2,
                    minLines: 1,
                    style: subtitlestyle(color: Colors.black),
                    decoration: const InputDecoration(
                      // filled: true,
                      hintText: "아침",
                      // border: OutlineInputBorder(),
                      // labelText: 'Product Name',
                    ),
                    // obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  // margin: EdgeInsets.only(left: 4,top: 5),
                  child: IconButton(

                    onPressed: () async {
                      picStr = await Navigator.pushNamed(context, '/imagecl');
                      setState(() {});

                      _breakfastController.text = picStr;

                      },
                      icon: Icon(Icons.camera_alt_outlined),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Container(
                  width: 300,
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    controller: _lunchController,
                    autofocus: false,
                    maxLines:2,
                    minLines: 1,
                    style: subtitlestyle(color: Colors.black),
                    decoration: const InputDecoration(
                      // filled: true,
                      hintText: "점심",
                      // border: OutlineInputBorder(),
                      // labelText: 'Product Name',
                    ),
                    // obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    picStr = await Navigator.pushNamed(context, '/imagecl');
                    setState(() {});
                    _lunchController.text = picStr;
                    },
                    icon: Icon(Icons.camera_alt_outlined),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Container(
                  width: 300,
                  child: TextFormField(
                    style: subtitlestyle(color: Colors.black),
                    // The validator receives the text that the user has entered.
                    controller: _dinnerController,
                    autofocus: false,
                    maxLines:2,
                    minLines: 1,
                    decoration: const InputDecoration(
                      
                      // filled: true,
                      hintText: "저녁",
                      // border: OutlineInputBorder(),
                      // labelText: 'Product Name',
                    ),
                    // obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    picStr = await Navigator.pushNamed(context, '/imagecl');
                    setState(() {});
                    _dinnerController.text = picStr;
                    },
                    icon: Icon(Icons.camera_alt_outlined),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Container(
                  width: 300,
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    controller: _latemealController,
                    autofocus: false,
                    maxLines:2,
                    minLines: 1,
                    style: subtitlestyle(color: Colors.black),
                    decoration: const InputDecoration(
                      // filled: true,
                      hintText: "야식",
                      // border: OutlineInputBorder(),
                      // labelText: 'Product Name',
                    ),
                    // obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    picStr = await Navigator.pushNamed(context, '/imagecl');
                    setState(() {});

                    _latemealController.text = picStr;

                    },
                    icon: Icon(Icons.camera_alt_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Future<void> addevent( String uid, String breakfast, String lunch,
      String dinner,String late_meal,String name, String day) async {
    FirebaseFirestore.instance.collection('menu')
    .add({
      "uid": uid
    })
    .then((value) {
      FirebaseFirestore.instance.collection('menu').doc(value.id)
      .update({
        "id": value.id,
        "breakfast": breakfast,
        "launch": lunch,
        "dinner": dinner,
        "late_meal": late_meal,
        "name": name,
        //FieldValue.serverTimestamp(),
        "day" : day
        });
    });
  }

void addMeal( String uid, String breakfast, String lunch, String dinner,String late_meal,String name, String day){

 final mealInfo = <String, dynamic>{
        "uid": uid,
        "breakfast": breakfast,
        "launch": lunch,
        "dinner": dinner,
        "late_meal": late_meal,
        "name": name,
        //FieldValue.serverTimestamp(),
        "day" : day,
        "id": uid+day
};

final mealList = FirebaseFirestore.instance
    .collection("menu")
    .doc(uid+day)
    .set(mealInfo)
    .onError((e, _) => print("Error writing document: $e"));

}


  Future<void> _addMenuData(String menu) async {
    String? breakfast;
    String? lunch;
    String? dinner;
    String? night;

    if(_dietTDay=="아침")
      breakfast = menu;
    if(_dietTDay=="점심")
      breakfast = menu;
    if(_dietTDay=='저녁')
      breakfast = menu;
    else if(_dietTDay=='야식')
      breakfast = menu;
  }



}

