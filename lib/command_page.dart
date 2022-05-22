
import 'package:flutter/material.dart';
import 'package:squidgame/month_calendar.dart';

class CommandPage extends StatefulWidget {
  @override
  _CommandPageState createState() => _CommandPageState();
}

class _CommandPageState extends State<CommandPage> {

  int _selectedIndex = 0; // 처음에 나올 화면 지정

  // 이동할 페이지
  List _pages = [MonthCalendar(), Text('page2'), Text('page3')];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        body: Center(
          child: _pages[_selectedIndex], // 페이지와 연결
        ),

        // BottomNavigationBar 위젯
        bottomNavigationBar: BottomNavigationBar(
          //type: BottomNavigationBarType.fixed, // bottomNavigationBar item이 4개 이상일 경우
         
          // 클릭 이벤트 
          onTap: _onItemTapped,

          currentIndex: _selectedIndex, // 현재 선택된 index

          // BottomNavigationBarItem 위젯
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Home'),

            BottomNavigationBarItem(
                icon: Icon(Icons.search), label: 'Home'),

            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Home'),

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