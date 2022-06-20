
import 'package:flutter/material.dart';
import 'package:squidgame/month_calendar.dart';
import 'package:squidgame/textstyle.dart';
import 'package:squidgame/youtube_page.dart';
import 'SearchFriends.dart';
import './agora/chatroom.dart';
class CommandPage extends StatefulWidget {
  @override
  _CommandPageState createState() => _CommandPageState();
}

class _CommandPageState extends State<CommandPage> {

  int _selectedIndex = 0; // 처음에 나올 화면 지정

  // 이동할 페이지
  List _pages = [MonthCalendar(), SearchFreinds(), ChatRoomPage(), YoutubePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        body: Center(
          child: _pages[_selectedIndex], // 페이지와 연결
        ),

        // BottomNavigationBar 위젯
        bottomNavigationBar: BottomNavigationBar(
          selectedIconTheme: IconThemeData(color: Colors.black),
          unselectedIconTheme: IconThemeData(color: Colors.grey),
          selectedLabelStyle: subtitlestyle(color: Colors.black),
          unselectedLabelStyle: subtitlestyle(color: Colors.grey),
          //type: BottomNavigationBarType.fixed, // bottomNavigationBar item이 4개 이상일 경우
         
          // 클릭 이벤트 
          onTap: _onItemTapped,

          currentIndex: _selectedIndex, // 현재 선택된 index

          // BottomNavigationBarItem 위젯
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Home'),

            BottomNavigationBarItem(
                icon: Icon(Icons.manage_accounts_rounded), label: 'Friend'
            ),

            BottomNavigationBarItem(
                icon: Icon(Icons.quick_contacts_dialer_outlined), label: 'Call Chat'),
                
            BottomNavigationBarItem(
                icon: Icon(Icons.video_collection_outlined), label: 'Youtube'),

         ],
        )
      );
    }

  void _onItemTapped(int index) {
    // state 갱신
    setState(() {
      _selectedIndex = index; // index는 item 순서로 0, 1, 2로 구성
    });
  }
}