import 'package:flutter/material.dart';
import 'package:squidgame/CrudFunction.dart';
import 'package:squidgame/InstanceDeclare.dart';
import 'package:squidgame/color.dart';
import 'package:squidgame/productmodel.dart';
import 'package:squidgame/textstyle.dart';

class Search extends StatefulWidget {
  Search(this.userList);
  late List<user> userList;

  @override
  _SearchState createState() => _SearchState(userList);
}

class _SearchState extends State<Search> {
  _SearchState(this.userList);
  late List<user> userList;
  var crudFunction = CrudFunction();
  TextEditingController textEditingController = TextEditingController();
  user? searchedUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      appBar: AppBar(
        backgroundColor: Primary,
        elevation: 0.0,
        actions: <Widget>[],
        centerTitle: true,
        shadowColor: Color(0xffC0CEDB),
        title: Text('Search',
            style: headingstyle()),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
            child: TextField(
              controller: textEditingController,
              onChanged: (element) {
                setState(() {
                  if (userList.where((e) => e.name == element).isNotEmpty) {
                    searchedUser = userList.where((e) => e.name == element).first;
                  } else {
                    searchedUser = null;
                  }
                });
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: (searchedUser != null)
                    ? [searchedUserCard(searchedUser!,context)]
                    : [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget searchedUserCard(user user,context) {
  return Container(
    child: Column(
      children: [
        Row(
          children: [
            Text(user.name,style: subtitlestyle(size: 20)),
            Spacer(),
            TextButton(
              child: Text("Add Friend",style: subtitlestyle(color: Colors.black, size: 15)),
              onPressed: () {
                crudFunction.addNewFriend(user.uid);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                      Text("Added to friend list.")),
                );
                Navigator.pop(context);
              },
            ),

          ],
        ),
        Divider(
          height: 1.0,
          thickness: 1,
          color: Colors.black,


        ),
      ],
    ),

  );
}
