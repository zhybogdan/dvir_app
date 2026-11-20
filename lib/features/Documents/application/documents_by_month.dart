import 'package:dvir/features/Documents/domain/models/document.dart';

/// The papers added in one calendar month, as the phone's clock counts it.
typedef MonthGroup = ({int year, int month, List<Document> items});

/// [documents] cut into months, in the order they arrive.
///
/// Papers are filed by month because a scan is added on the day it arrives,
/// and that is the only order anybody remembers it in — "the contract came in
/// August", never "the contract is the fourth".
///
/// A month starts wherever the month changes, rather than collecting every
/// paper of that month wherever it stands: the list arrives newest first, so
/// the two are the same thing, and this way the groups never reorder what the
/// repository decided.
///
/// The month is the local one. `created_at` is stored in UTC, and a paper
/// added at half past one on the first of the month in Kyiv belongs to that
/// month, not to the one before.
List<MonthGroup> groupByMonth(List<Document> documents) {
  final groups = <MonthGroup>[];

  for (final document in documents) {
    final date = document.createdAt.toLocal();
    final last = groups.lastOrNull;

    if (last != null && last.year == date.year && last.month == date.month) {
      last.items.add(document);
    } else {
      groups.add((year: date.year, month: date.month, items: [document]));
    }
  }

  return groups;
}
