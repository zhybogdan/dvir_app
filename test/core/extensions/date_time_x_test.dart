import 'package:dvir/core/extensions/date_time_x.dart';
import 'package:flutter_test/flutter_test.dart';

// Both shapes are pinned here rather than where they are used: a test that
// built the expected string the same way the code does would agree with itself
// whatever the format became.
void main() {
  test('a date shown to a person reads day first, padded', () {
    expect(DateTime(2026, 11, 9).asShortDate, '09.11.2026');
    expect(DateTime(2026, 1, 1).asShortDate, '01.01.2026');
  });

  test('a date in a file name reads year first, so names sort by date', () {
    expect(DateTime(2026, 11, 9).asFileStamp, '2026-11-09');
    expect(DateTime(2026, 1, 1).asFileStamp, '2026-01-01');
  });
}
