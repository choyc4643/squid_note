// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils.dart';
import 'textstyle.dart';
import 'writing_page.dart';

class WeekCalendar extends StatefulWidget {
  @override
  _WeekCalendarState createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendar> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
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
          const Center(
            child: SizedBox(
                width: 40,
                height: 40,
                child: Image(
                  image: AssetImage('assets/hamburger1.png'),
                )),
          ),
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

  Future<dynamic> SelectDialog() {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Stack(children: [
          Dialog(
              backgroundColor: const Color(0xff00203E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: SizedBox(
                height: 300,
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        '아침',
                        style: headingstyle(size: 30, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WritingPage()),
                        );
                      },
                    ),
                    const Divider(
                      color:  Color(0xffF3F4F6),
                    ),
                    ListTile(
                      title: Text(
                        '점심',
                        style: headingstyle(size: 30, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WritingPage()),
                        );
                      },
                    ),
                    const Divider(
                      color: Color(0xffF3F4F6),
                    ),
                    ListTile(
                      title: Text(
                        '저녁',
                        style: headingstyle(size: 30, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WritingPage()),
                        );
                      },
                    ),
                    const Divider(
                      color: Color(0xffF3F4F6),
                    ),
                    ListTile(
                      title: Text(
                        '야식',
                        style: headingstyle(size: 30, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WritingPage()),
                        );
                      },
                    )
                  ],
                ),
              )),
        ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SelectDialog();
        },
        backgroundColor: const Color(0xff00203E),
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color(0xffC0CEDB),
      body: Container(
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: Column(
          children: [
            TableCalendar<Event>(
              headerStyle: HeaderStyle(
                titleTextStyle: headingstyle(size: 50),
                formatButtonVisible: false,
                titleCentered: true,
              ),
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              calendarStyle: const CalendarStyle(
                // Use `CalendarStyle` to customize the UI
                outsideDaysVisible: false,
              ),
              calendarBuilders: CalendarBuilders(todayBuilder: defaultBuilder),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffF3F4F6),
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 1.0, color: Colors.black)),
                          width: 340,
                          height: 100,
                          // color:  Color(0xffF3F4F6),
                          child: Container(
                              padding: const EdgeInsets.all(20),
                              child: const Text('squid game')),

                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 10,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
