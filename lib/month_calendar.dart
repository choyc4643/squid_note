// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:squidgame/color.dart';
import 'package:squidgame/command_page.dart';
import 'package:squidgame/productmodel.dart';
import 'package:squidgame/textstyle.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils.dart';
import 'InstanceDeclare.dart';
import 'adddiet.dart';

var firebase = FirebaseFirestore.instance;

class MonthCalendar extends StatefulWidget {
  @override
  _MonthCalendarState createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  bool is_social = true;
  int eventcnt = 0;
  // DateFormat dateForm = DateFormat('MM. dd');
  // String dateString = DateFormat('yyyy-MM-dd').format(DateTime.now());

  var userRef2 = firebase
      .collection("user")
      .where("FriendsUidList", arrayContains: firebaseAuth.currentUser!.uid);

  @override
  void initState() {
    super.initState();

    _selectedDay = kToday;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  Widget? defaultBuilder(context, day1, day2) {
    return Container(
      child: Stack(
        children: [
          // Center(
          //   child: SizedBox(
          //     width: 40,
          //     height: 40,
          //     child: Image(image: AssetImage('assets/hamburger1.png'),)
          //   ),
          // ),
          Center(
            child: Text(
              day1.day.toString(),
              style: const TextStyle(
                  // fontSize: 12,
                  ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: Column(
          children: [
            TableCalendar<Event>(
              headerStyle: HeaderStyle(
                titleTextStyle: headingstyle(size: 25),
                formatButtonTextStyle: subtitlestyle(),
                formatButtonVisible: false,
                titleCentered: true,
              ),
              firstDay: kFirstDay,
              lastDay: kToday,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              calendarStyle: CalendarStyle(
                defaultTextStyle: subtitlestyle(weight: FontWeight.w700),
                //TODO: 마커 수정해야함. 파이어베이스에서 데이터 개수 어떻게 받아오지...
                markersMaxCount: 0,
                todayTextStyle: subtitlestyle(weight: FontWeight.w700),
                holidayTextStyle: subtitlestyle(weight: FontWeight.w700),
                outsideTextStyle: subtitlestyle(weight: FontWeight.w700),
                weekendTextStyle: subtitlestyle(weight: FontWeight.w700),
                disabledTextStyle: subtitlestyle(weight: FontWeight.w700),
                rangeEndTextStyle: subtitlestyle(weight: FontWeight.w700),
                selectedTextStyle: subtitlestyle(weight: FontWeight.w700),
                selectedDecoration: BoxDecoration(color: SubPrimary),
                rangeStartTextStyle: subtitlestyle(weight: FontWeight.w700),
                withinRangeTextStyle: subtitlestyle(weight: FontWeight.w700),
                // Use `CalendarStyle` to customize the UI
                outsideDaysVisible: false,
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: subtitlestyle(weight: FontWeight.w900),
                  weekendStyle: subtitlestyle(weight: FontWeight.w900)),
              calendarBuilders: CalendarBuilders(
                todayBuilder: defaultBuilder,
              ),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(height: 8.0),
            // Text(_selectedDay.toString()),
            Container(
                margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      DateFormat('MM. dd').format(_selectedDay!),
                      style: headingstyle(size: 20),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          month_calendar_dialog();
                        },
                        icon: Icon(Icons.calendar_month)),
                    SizedBox(
                      width: 20,
                    )
                  ],
                )),
            // is_social ? mealList() : socialMealList(),
            mealStream(_selectedDay.toString())
          ],
        ),
      ),
      floatingActionButton: _createFloatingActionButton(context),
    );
  }

  List<Card> _buildGridCards(
      BuildContext context, List<food> userlist, String selday) {
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
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20, 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Image.asset(
                                    "assets/sunrise.png",
                                    width: 24,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        // color: Morning
                                        ),
                                    child: Text(
                                      '아침',
                                      style: subtitlestyle(size: 20),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                                width: 200,
                                child: Text(
                                  food.breakfast,
                                  style: subtitlestyle(size: 20),
                                  maxLines: 5,
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
                              Column(
                                children: [
                                  Icon(Icons.wb_sunny_outlined),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      // color: Lunch,
                                    ),
                                    child: Text(
                                      '점심',
                                      style: subtitlestyle(size: 20),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 200,
                                margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                                child: Text(
                                  food.launch,
                                  style: subtitlestyle(size: 20),
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
                              Column(
                                children: [
                                  Image.asset(
                                    "assets/sunset.png",
                                    width: 24,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      // color: Dinner,
                                    ),
                                    child: Text(
                                      '저녁',
                                      style: subtitlestyle(size: 20),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 200,
                                margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                                child: Text(
                                  food.dinner,
                                  style: subtitlestyle(size: 20),
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
                              Column(
                                children: [
                                  Image.asset(
                                    "assets/night.png",
                                    width: 24,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      // color: MidNightSnack,
                                    ),
                                    child: Text(
                                      '야식',
                                      style: subtitlestyle(size: 20),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 200,
                                margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                                child: Text(
                                  food.late_meal,
                                  style: subtitlestyle(size: 20),
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
              ),
            ],
          ));
    }).toList();
  }

  StreamBuilder<List<food>> mealStream(String selday) {
    return StreamBuilder<List<food>>(
      stream: crudFunction.eventstream2(selday),
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
                  childAspectRatio: 8.0 / 9.5,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  // physics: NeverScrollableScrollPhysics(),
                  children: _buildGridCards(context, productList, selday),
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

  StreamBuilder<List<food>> socialMealStream(String selday) {
    return StreamBuilder<List<food>>(
      stream: crudFunction.eventstream2(selday),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          var productList = snapshot.data!;
          return ListView(shrinkWrap: true, children: [
            Container(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(5),
                childAspectRatio: 8.0 / 10.0,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                children: _buildGridCards(context, productList, selday),
              ),
            ),
          ]);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Expanded mealList() {
    return Expanded(
      child: ValueListenableBuilder<List<Event>>(
        valueListenable: _selectedEvents,
        builder: (context, value, _) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              return value[index].uid == '1'
                  ? Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Background,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(width: 1.0, color: Background)),
                        width: 340,
                        // height: 100,
                        // color:  Color(0xffF3F4F6),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '아침',
                                style: subtitlestyle(
                                    size: 20, weight: FontWeight.w900),
                              ),
                              Text(
                                _selectedEvents.value[index].breakfast,
                                style: subtitlestyle(
                                    size: 17, weight: FontWeight.w900),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '점심',
                                style: subtitlestyle(
                                    size: 20, weight: FontWeight.w900),
                              ),
                              Text(
                                _selectedEvents.value[index].launch,
                                style: subtitlestyle(
                                    size: 17, weight: FontWeight.w900),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '저녁',
                                style: subtitlestyle(
                                    size: 20, weight: FontWeight.w900),
                              ),
                              Text(
                                _selectedEvents.value[index].dinner,
                                style: subtitlestyle(
                                    size: 17, weight: FontWeight.w900),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '야식',
                                style: subtitlestyle(
                                    size: 20, weight: FontWeight.w900),
                              ),
                              Text(
                                _selectedEvents.value[index].late_meal,
                                style: subtitlestyle(
                                    size: 17, weight: FontWeight.w900),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),

                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 10,
                        ),
                      ),
                    )
                  : Container(
                      child: Text('not this user\'s content'),
                    );
            },
          );
        },
      ),
    );
  }

  Expanded socialMealList() {
    return Expanded(
      child: ValueListenableBuilder<List<Event>>(
        valueListenable: _selectedEvents,
        builder: (context, value, _) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              return Center(
                child: InkWell(
                  onTap: () {
                    //   Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) =>  DetailPage(events: value[index],)),
                    // );
                    Navigator.pushNamed(context, '/commant');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xffF3F4F6),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(width: 1.0, color: Colors.white)),
                    width: 340,
                    // height: 100,
                    // color:  Color(0xffF3F4F6),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            value[index].name,
                            style: subtitlestyle(
                                size: 20, weight: FontWeight.w900),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 50,
                                height: 30,
                                child: Text('아침'),
                                decoration: BoxDecoration(
                                    color: value[index].breakfast != ''
                                        ? Color.fromARGB(255, 69, 201, 129)
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(width: 0)),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 50,
                                height: 30,
                                child: Text('점심'),
                                decoration: BoxDecoration(
                                    color: value[index].launch != ''
                                        ? Color.fromARGB(255, 233, 242, 109)
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(width: 0)),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 50,
                                height: 30,
                                child: Text('저녁'),
                                decoration: BoxDecoration(
                                    color: value[index].dinner != ''
                                        ? Color.fromARGB(255, 230, 159, 27)
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(width: 0)),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 50,
                                height: 30,
                                child: Text('야식'),
                                decoration: BoxDecoration(
                                    color: value[index].late_meal != ''
                                        ? Color.fromARGB(255, 239, 95, 95)
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(width: 0)),
                              )
                            ],
                          )
                        ],
                      ),
                    ),

                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 10,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget _createFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Button,
      elevation: 8.0,
      child: Image.asset("assets/write.png", color: Colors.white,width: 30,),
      // Icon(Icons.draw_outlined, color: Colors.white),
      onPressed: () {
        Navigator.pushNamed(context, '/adddiet',
            arguments: _selectedDay.toString());
      },
    );
  }

  void _onDaySelected2(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
    Navigator.pop(context);
  }

  Future<dynamic> month_calendar_dialog() {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: const Color(0xffFFFFFE),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Stack(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: 311,
                height: 540,
                child: TableCalendar<Event>(
                  availableGestures: AvailableGestures.horizontalSwipe,
                  firstDay: kFirstDay,
                  lastDay: kToday,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: CalendarFormat.month,
                  rangeSelectionMode: _rangeSelectionMode,
                  eventLoader: _getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  rowHeight: 70,
                  headerStyle: const HeaderStyle(
                      leftChevronVisible: true,
                      rightChevronVisible: true,
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(
                        fontFamily: 'Bold',
                        fontSize: 24,
                      )),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, list) {
                      Container();
                    },
                    headerTitleBuilder: (context, day) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            DateFormat('yyyy\nMMMM').format(day),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: 'Bold', fontSize: 20),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    },
                  ),
                  daysOfWeekHeight: 20,
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(fontFamily: 'Bold'),
                    weekendStyle: TextStyle(fontFamily: 'Bold'),
                  ),
                  calendarStyle: const CalendarStyle(
                    markersMaxCount: 0,
                    // Use `CalendarStyle` to customize the UI
                    outsideDaysVisible: false,
                    weekendTextStyle: TextStyle(fontFamily: 'Bold'),
                    disabledTextStyle:
                        TextStyle(fontFamily: 'Bold', color: Colors.grey),
                    outsideTextStyle: TextStyle(fontFamily: 'Bold'),
                    holidayTextStyle: TextStyle(fontFamily: 'Bold'),
                    selectedTextStyle: TextStyle(fontFamily: 'Bold'),
                    todayTextStyle: TextStyle(
                      fontFamily: 'Bold',
                      decoration: TextDecoration.underline,
                    ),
                    defaultTextStyle: TextStyle(fontFamily: 'Bold'),
                  ),
                  onDaySelected: _onDaySelected2,
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
              ),
            ]));
      },
    );
  }
}
