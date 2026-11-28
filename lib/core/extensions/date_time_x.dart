/// How a date becomes text, in the two shapes the app needs it.
///
/// Both are written by hand rather than with `intl`'s `DateFormat`, and the
/// reason is worth keeping: a Ukrainian month spelled out needs its genitive
/// form ("9 листопада", not "9 листопад"), which `DateFormat.yMMMMd('uk')`
/// does give — but nothing in the app shows a date to a person yet except the
/// one place below, and a locale-aware formatter brings its own symbol data
/// into the build for a single string.
///
/// This is the one place to change when dates start appearing properly: a list
/// of documents by day, a reminder that something expires. At that point this
/// becomes `DateFormat`, and no call site moves.
extension DateTimeX on DateTime {
  /// For showing a person: `09.11.2026`.
  String get asShortDate => '${_two(day)}.${_two(month)}.$year';

  /// For naming a file: `2026-11-09`, so copies made on different days sort by
  /// name as well as by date.
  String get asFileStamp => '$year-${_two(month)}-${_two(day)}';

  /// Whole calendar days from this date to [later]: 23:50 yesterday is one
  /// day before 00:10 today, not zero. Counted on UTC midnights, so a day
  /// that loses an hour to the clocks going forward still counts as one.
  int calendarDaysUntil(DateTime later) {
    final from = toLocal();
    final to = later.toLocal();

    return DateTime.utc(
      to.year,
      to.month,
      to.day,
    ).difference(DateTime.utc(from.year, from.month, from.day)).inDays;
  }

  String _two(int value) => value.toString().padLeft(2, '0');
}
