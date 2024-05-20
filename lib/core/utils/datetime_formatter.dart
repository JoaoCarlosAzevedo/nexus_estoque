String datetimeToYYYYMMDD(DateTime date) {
  final newDate = date.toIso8601String().split('T').first;
  return newDate.replaceAll('-', '');
}
