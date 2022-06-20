import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:squidgame/InstanceDeclare.dart';
import 'package:squidgame/textstyle.dart';
import 'dart:io';
import 'color.dart';
import 'productmodel.dart';
var firebaseAuth = FirebaseAuth.instance;
class FriendsDetail extends StatefulWidget {
  @override
  State<FriendsDetail> createState() => _FriendsDetailState();
}

class _FriendsDetailState extends State<FriendsDetail> {
  @override
  Widget build(BuildContext context) {
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)

    user userModel = ModalRoute.of(context)!.settings.arguments as user ;
    return Scaffold(
      backgroundColor: Background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Primary,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
            // Navigator.pushNamed(context, '/SearchFriends');
          },
        ),
        title: Text(userModel.name+' diet',style: headingstyle(color: Colors.black)),
        actions: <Widget>[



        ],
      ),
      body: Center(
        child: mealStream(userModel.uid),
        // showmenu(context,userModel.uid),
      ),
    );
  }

  StreamBuilder<List<food>> mealStream(String user) {
    return StreamBuilder<List<food>>(
      stream: crudFunction.eventstream3(user),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length > 0) {
            var productList = snapshot.data!;
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/commant',
                    arguments: snapshot.data!);
                // print( snapshot.data!.map((e) => e.id).toString());
              },
              child: Container(
                // height: MediaQuery.of(context).size.height/1.5,
                child: GridView.count(
                  crossAxisCount: 1,
                  padding: const EdgeInsets.all(5),
                  childAspectRatio: 1.05 / 1,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  // physics: NeverScrollableScrollPhysics(),
                  children: _buildGridCards(context, productList),
                ),
              ),
            );
          } else {
            return Container(
                margin: EdgeInsets.only(top: 200),
                child: Text(
                  '아직 등록된 식단이 없습니다.',
                  style: subtitlestyle(size: 20),
                ));
          }
        } else
          return CircularProgressIndicator();
      },
    );
  }

    List<Card> _buildGridCards(
      BuildContext context, List<food> userlist) {
    //List<Product> products = ProductsRepository.loadProducts(Category.all);
    List<food> products = userlist;
    if (products.isEmpty) {
      print('empty');
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return products.map((food) {
      return Card(
          color: Background,
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20,20,0,0),
                child: Text(food.day.replaceAll("00:00:00.000Z",  ''),style: headingstyle(size: 20),),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15,0,10,0),
                              child: Image.asset(
                                "assets/sunrise.png",
                                width: 24,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                              width: 200,
                              child: Text(
                                food.breakfast,
                                style: subtitlestyle(size: 20),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15,0,10,0),
                              child: 
                              Icon(Icons.wb_sunny_outlined),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                              width: 200,
                              child: Text(
                                food.launch,
                                style: subtitlestyle(size: 20),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15,0,10,0),
                              child: Image.asset(
                                "assets/sunset.png",
                                width: 24,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                              width: 200,
                              child: Text(
                                food.dinner,
                                style: subtitlestyle(size: 20),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15,0,10,0),
                              child: Image.asset(
                                "assets/night.png",
                                width: 24,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                              width: 200,
                              child: Text(
                                food.late_meal,
                                style: subtitlestyle(size: 20),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ));
    }).toList();
  }

  StreamBuilder showmenu(BuildContext context, String uid) {
    // String docId2 = ModalRoute.of(context)!.settings.arguments as String;
    user userModel = ModalRoute.of(context)!.settings.arguments as user ;

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('menu')
        // .orderBy('timestamp', descending: true)
            .where("uid", isEqualTo: userModel.uid.toString())
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return const Text('Firestore snapshot is loading..');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) => 
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/commant'
                  , arguments: snapshot.data!
              );
              },
              child: Card(
                child:
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
            
                          Column(
            
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget> [
                              Container(
            
                                child: Text(
                                  "${snapshot.data?.docs[index]['day']}",
                                  style: subtitlestyle(size: 20),
                                  // maxLines: 1,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xff8FC34F),
                                ),
                                child: Text(
                                  '아침',
                                  style: subtitlestyle(size: 20),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "${snapshot.data?.docs[index]['breakfast']}",
                                  style: subtitlestyle(size: 20),
                                  // maxLines: 1,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffFFFE54),
                                ),
                                child: Text(
                                  '점심',
                                  style:subtitlestyle(size: 20),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "${snapshot.data?.docs[index]['launch']}",
                                  style: subtitlestyle(size: 20),
                                  // maxLines: 1,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffE99D42),
                                ),
                                child: Text(
                                  '저녁',
                                  style:subtitlestyle(size: 20),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "${snapshot.data?.docs[index]['dinner']}",
                                  style: subtitlestyle(size: 20),
                                  // maxLines: 1,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffC1281B),
                                ),
                                child: Text(
                                  '야식',
                                  style:subtitlestyle(size: 20),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "${snapshot.data?.docs[index]['late_meal']}",
                                  style: subtitlestyle(size: 20),
                                  // maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
            
                    ],
                  ),
            
            
              ),
            ),

          );
        });
  }
}
