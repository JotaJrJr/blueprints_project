extension DateTimeExtension on DateTime {
  DateTime firstDayOfWeek() {
    return add(Duration(days: -weekday));
  }

  DateTime firstDayOfMonth() {
    return add(Duration(days: -day));
  }
}
