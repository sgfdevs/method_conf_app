import 'package:timezone/timezone.dart' as tz;

DateTime? utcStringToCst(String? dateString) {
  if (dateString == null) {
    return null;
  }

  final location = tz.getLocation('America/Chicago');

  final parsedDate = DateTime.parse(dateString);

  final tzDateTime = tz.TZDateTime(
    location,
    parsedDate.year,
    parsedDate.month,
    parsedDate.day,
    parsedDate.hour,
    parsedDate.minute,
    parsedDate.second,
    parsedDate.millisecond,
    parsedDate.microsecond,
  );

  final utcDateTime = tzDateTime.toUtc();

  return utcDateTime;
}

String? cstToUtcString(DateTime? date) {
  if (date == null) {
    return null;
  }

  final location = tz.getLocation('America/Chicago');
  final tzDateTime = tz.TZDateTime.from(date.toUtc(), location);
  final dateString = tzDateTime.toString().split('.').first;

  return dateString;
}
