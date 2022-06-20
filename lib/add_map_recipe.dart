import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squidgame/CrudFunction.dart';
import 'package:squidgame/textstyle.dart';
import 'color.dart';
import 'map.dart';
import 'package:squidgame/InstanceDeclare.dart';

//var mapRecipeRef = firebase.collection("mapRecipe");
class SaveMap extends StatefulWidget {
  SaveMap ({ Key? key }): super(key: key);
  // String? lan;
  // String? lat;
  // String? location;

  @override
  _SaveMapState createState() => _SaveMapState();
  }

  class _SaveMapState extends State<SaveMap> {
    final _StoreNameController = TextEditingController(); //text form
    final _formKey = GlobalKey<FormState>();
    final _StoreCommentController = TextEditingController();
    late ScrollController _scrollController;
    // final result = await Navigator.pushNamed(context, "/myNextRoute");
    var locate;
    dynamic receipt;
    final _receiptControlloer = TextEditingController();

    @override
    void initState() {
      super.initState();
      _scrollController = ScrollController();
    }

  @override
  Widget build(BuildContext context) {
    String day = ModalRoute.of(context)?.settings.arguments as String;

    return CupertinoPageScaffold(
      child:GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
      child: Scaffold(
        backgroundColor: Background,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Primary,
        title: Text("Cafeteria", style: headingstyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        // actions: [
        //   TextButton.icon(
        //       onPressed: () {
        //         //save in firebase
        //
        //       },
        //       icon: Icon(Icons.save_alt),
        //       label: Text('save')),
        // ],

      ),
      body:SingleChildScrollView(
        controller: _scrollController,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2.8,
              child: MapMarker(),
            ),
            Text(onchangeLocation.toString()),
            // Text(widget.lan.toString()),
            // Text(widget.location.toString()),
            //using text controller for store name
            //using comment about the store
            _StoreInputController(),
            // Text(location),
            SizedBox(height: 20,),
          ],
        ),
      ),
      ),
        bottomSheet: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: 0),
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  primary: SubPrimary,
                ),
                onPressed: () {
                  var location = onchangeLocation.toString();
                  var uid = FirebaseAuth.instance.currentUser?.uid;
                  addMapMarker(uid!, _StoreNameController.text, _StoreCommentController.text, 1, location,day,_receiptControlloer.text);
                  Navigator.pop(context);
                },
                child: Text('확인'),
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
    Widget _StoreInputController(){
      return Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width/1.2,
              height: 50,
              child:TextFormField(
              // The validator receives the text that the user has entered.
              controller: _StoreNameController,
              autofocus: false,
              maxLines:1,
              decoration: const InputDecoration(
                filled: true,
                hintText: "식당 이름을 입력해주세요",
                border: OutlineInputBorder(),
                // labelText: 'Product Name',
              ),
              onTap: () {
                //120만큼 500milSec 동안 뷰를 올려줌
                _scrollController.animateTo(120.0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease);
              },
              // obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),),
            SizedBox(height: 10,),
            SizedBox(
              width: MediaQuery.of(context).size.width/1.2,
              height: 50,
              child:TextFormField(
              // The validator receives the text that the user has entered.
              controller: _StoreCommentController,
              autofocus: false,
              maxLines:1,
              decoration: const InputDecoration(
                filled: true,
                hintText: "식당 한줄평을 입력해주세요",
                border: OutlineInputBorder(),
                // labelText: 'Product Name',
              ),
              onTap: () {
                //120만큼 500milSec 동안 뷰를 올려줌
                _scrollController.animateTo(120.0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease);
              },
              // obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
      ),
      SizedBox(height: 10,),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(33.0,0,0,0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width/1.4,
                    height: 50,
                    child:TextFormField(
                      // The validator receives the text that the user has entered.
                      controller: _receiptControlloer,
                      autofocus: false,
                      maxLines:1,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: "영수증 등록 (선택)",
                        border: OutlineInputBorder(),
                        // labelText: 'Product Name',
                      ),
                      onTap: () {
                        //120만큼 500milSec 동안 뷰를 올려줌
                        _scrollController.animateTo(120.0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      // obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),),
                ),
                Container(
                  // margin: EdgeInsets.only(left: 4,top: 5),
                  child: IconButton(

                    onPressed: ()async {
                      receipt = await Navigator.pushNamed(context, '/receipt');
                      setState(() {});
                      _receiptControlloer.text = receipt;

                    },
                    icon: Icon(Icons.camera_alt_outlined),
                  ),
                ),
              ],
            ),
          ],
        ),

      );
    }



    void addMapMarker( String uid, String storeName,String storComment, int active, String location,String day,String receiptdata) async {
      // eventRef.doc(documentId.toString()).set({
      //   "storeName": storeName,
      //   "active": active,
      //   "location": location,
      //   "timestamp": FieldValue.serverTimestamp(),
      //
      // });
      final mapInfo = <String, dynamic>{
        "storeName": storeName,
        "storComment":storComment,
        "active": active,
        "location": location,
        "timestamp": FieldValue.serverTimestamp(),
        "id":uid+day,
        "docId":uid+day,
        "receipt":receiptdata
      };

      final mapList = FirebaseFirestore.instance
          .collection("menu")
          .doc(uid+day)
          .collection('maprecipe')
          .doc(uid+day)
          .set(mapInfo)
          .onError((e, _) => print("Error writing document: $e"));
    }

}
