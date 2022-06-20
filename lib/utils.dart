// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String uid;
  final String breakfast;
  final String launch;
  final String dinner;
  final String late_meal;
  final String name;
  final bool is_school;
  final DateTime day;


  const Event(this.uid, this.breakfast,this.launch, this.dinner, this.late_meal, this.name, this.is_school, this.day);

  // @override
  // String toString() => title;
}

class Meal{
    final String foods;
  final bool is_school;
  final bool is_outside;
  
  const Meal(this.foods, this.is_outside, this.is_school);
}

/// Example events.
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(
        item % 4 + 1, (index) => Event('1','Event $item | ${index + 1}','a','','','',true,DateTime.now())))
  ..addAll({
    kToday: [
      Event('1','미역국','닭가슴살','','삼겹살','서예지',true,DateTime.now()),
      Event('2','된장국','치킨','냉면','돼지갈비','김민수', false,DateTime.now()),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

