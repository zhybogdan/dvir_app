import 'package:dvir/features/Documents/application/documents_by_month.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:flutter_test/flutter_test.dart';

// An object's papers are filed by the month they arrived in. What is pinned
// here is that the months follow the list's own order, that a year apart is a
// month apart, and that nothing is lost or moved on the way.

Document _paper(String id, DateTime createdAt) =>
    Document(id: id, title: id, storagePath: '$id.pdf', createdAt: createdAt);

void main() {
  test('consecutive papers of one month share a group, newest first', () {
    final groups = groupByMonth([
      _paper('passport', DateTime(2026, 11, 18)),
      _paper('act', DateTime(2026, 11, 2)),
      _paper('contract', DateTime(2026, 8, 30)),
    ]);

    expect(groups.map((group) => (group.year, group.month)), [
      (2026, 11),
      (2026, 8),
    ]);
    expect(groups.first.items.map((paper) => paper.id), ['passport', 'act']);
    expect(groups.last.items.map((paper) => paper.id), ['contract']);
  });

  test('the same month a year earlier is a month of its own', () {
    final groups = groupByMonth([
      _paper('new', DateTime(2026, 11, 1)),
      _paper('old', DateTime(2025, 11, 1)),
    ]);

    expect(groups.map((group) => (group.year, group.month)), [
      (2026, 11),
      (2025, 11),
    ]);
  });

  test('no papers, no months', () {
    expect(groupByMonth(const []), isEmpty);
  });
}
