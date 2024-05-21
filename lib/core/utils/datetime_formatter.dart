String datetimeToYYYYMMDD(DateTime date) {
  final newDate = date.toIso8601String().split('T').first;
  return newDate.replaceAll('-', '');
}

String yyyymmddToDate(String date) {
  return '${date.substring(6, 8)}/${date.substring(4, 6)}/${date.substring(0, 4)}';
}
