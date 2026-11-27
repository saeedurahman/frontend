import 'package:intl/intl.dart';

/// Short, plain dates for the khata screens.
abstract final class KhataFormat {
  static final _dayMonth = DateFormat('d MMM', 'en_US');
  static final _dayMonthYear = DateFormat('d MMM yyyy', 'en_US');
  static final _clock = DateFormat('HH:mm', 'en_US');

  /// "15 Dec", with the year only when it isn't this one.
  static String day(DateTime date, {DateTime? now}) =>
      date.year == (now ?? DateTime.now()).year
          ? _dayMonth.format(date)
          : _dayMonthYear.format(date);

  static String fullDay(DateTime date) => _dayMonthYear.format(date);

  /// "10:42".
  static String time(DateTime moment) => _clock.format(moment);

  /// "10:42" for today, "26 Nov, 10:42" for an older answer.
  static String asOf(DateTime moment, {DateTime? now}) {
    final today = now ?? DateTime.now();
    return daysBetween(moment, today) == 0
        ? time(moment)
        : '${day(moment, now: today)}, ${time(moment)}';
  }

  /// Whole calendar days from [from] to [to].
  static int daysBetween(DateTime from, DateTime to) =>
      DateTime.utc(to.year, to.month, to.day)
          .difference(DateTime.utc(from.year, from.month, from.day))
          .inDays;

  /// "today", "yesterday", "3 days ago", or the date after a month.
  static String ago(DateTime moment, {DateTime? now}) {
    final today = now ?? DateTime.now();
    final days = daysBetween(moment, today);
    if (days <= 0) return 'today';
    if (days == 1) return 'yesterday';
    if (days <= 30) return '$days days ago';
    return 'on ${day(moment, now: today)}';
  }

  static String days(int count) => count == 1 ? '1 day' : '$count days';

  /// "AK" for "Ahmed Khan": the letters shown in the round avatar.
  static String initials(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    String first(String w) => String.fromCharCode(w.runes.first).toUpperCase();
    return words.length == 1
        ? first(words.first)
        : '${first(words.first)}${first(words.last)}';
  }
}
