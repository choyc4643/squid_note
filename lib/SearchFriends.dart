// import 'package:toggle_switch/toggle_switch.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:squidgame/CrudFunction.dart';
import 'package:squidgame/InstanceDeclare.dart' as instance;
import 'package:squidgame/productmodel.dart';
import 'package:squidgame/textstyle.dart';
import 'color.dart';
import 'searchplz.dart';
import 'package:flutter/material.dart';

class SearchFreinds extends StatefulWidget {
  final List<String> list = List.generate(16, (index) => "Text $index");
  var crudFunction = CrudFunction();
  @override
  State<SearchFreinds> createState() => _SearchFreinds();
}

class _SearchFreinds extends State<SearchFreinds> {
  List<String> StringofUsername(BuildContext context, List<user> userlist) {
    //List<Product> products = ProductsRepository.loadProducts(Category.all);
    List<user> products = userlist;
    if (products.isEmpty) {
      return const <String>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return products.map((user) {
      return user.name;
    }).toList();
  }

  List<Card> _buildGridCards2(BuildContext context, List<food> userlist) {
    //List<Product> products = ProductsRepository.loadProducts(Category.all);
    List<food> products = userlist;
    if (products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return products.map((user) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Regular',
                        color: Colors.black,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Card> _buildGridCards(BuildContext context, List<user> userlist) {
    //List<Product> products = ProductsRepository.loadProducts(Category.all);
    List<user> products = userlist;
    if (products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return products.map((user) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Regular',
                        color: Colors.black,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      appBar: AppBar(
        backgroundColor: Primary,
        elevation: 0.0,
        actions: <Widget>[],
        leading: Container(),
        centerTitle: true,
        title: Text('Friend List',
            style: headingstyle(color: Colors.black)),
      ),
      body: SizedBox(
        height: 600,
        child: Column(
          children: [
            StreamBuilder<List<user>>(
              stream: instance.crudFunction.userStream(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  var userList = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                      child: Text('Want you add Friends?',
                          style: TextStyle(
                              fontFamily: 'bold',
                              fontSize: 16,
                              color: Colors.black)),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Search(userList)),
                        );
                        //showSearch(context: context, delegate: Search(StringofUsername(context, userList)));
                      },
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            StreamBuilder<DocumentSnapshot>(
                stream: instance.crudFunction
                    .streamMyUserModel(instance.firebaseAuth.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var k = snapshot.data!;
                    user myUserModel = user(
                      name: k["name"],
                      uid: k["uid"],
                      email: k["email"],
                      FriendsUidList: k["FriendsUidList"],
                      userphoto: k["userphoto"],
                    );
                    List myFriendsList = myUserModel.FriendsUidList;
                    List<Future<user>> myFriendsModelList =
                        instance.crudFunction.getMyFriends(myFriendsList);
                    //return Container();
                    return friendsCard(myFriendsModelList);
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ],
        ),
      ),
    );
  }
}

Widget friendsCard(List<Future<user>> myFriendsModelList) {
  return SizedBox(
    height: 400,
    child: ListView(
      children: myFriendsModelList
          .map((e) => FutureBuilder<user>(
                future: e,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    user userModel = snapshot.data!;
                    return Column(
                      children: [
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Text(
                                  userModel.name,
                                  style: subtitlestyle(size: 20),
                                )),
                                Spacer(),
                            TextButton(
                                child: Text(
                                  "Diet",
                                  style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                                ),
                                onPressed: () => {
                                  Duration(seconds: 2),
                                  Navigator.pushNamed(context, '/friendsdetail',arguments: userModel)
                                }),
                                SizedBox(width: 20,)
                          ],
                        ),
                        Divider(thickness: 1, color: Colors.black,indent: 30, endIndent: 30,)
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ))
          .toList(),
    ),
  );
}

// class Search extends SearchDelegate {
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return <Widget>[
//       IconButton(
//         icon: Icon(Icons.close),
//         onPressed: () {
//           query = "";
//         },
//       ),
//     ];
//   }
//
//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         Navigator.pop(context);
//       },
//     );
//   }
//
//   String selectedResult = "";
//
//   @override
//   Widget buildResults(BuildContext context) {
//     return Container(
//       child: Center(
//         child: Text(selectedResult),
//       ),
//     );
//   }
//
//   final List<String> listExample;
//   Search(this.listExample);
//
//   List<String> recentList = ["", ""];
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<String> suggestionList = [];
//     query.isEmpty
//         ? suggestionList = recentList //In the true case
//         : suggestionList.addAll(listExample.where(
//       // In the false case
//           (element) => element.contains(query),
//     ));
//
//     return ListView.builder(
//       itemCount: suggestionList.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(
//             suggestionList[index],
//           ),
//           leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
//           onTap: (){
//             selectedResult = suggestionList[index];
//             showResults(context);
//           },
//         );
//       },
//     );
//   }
// }
