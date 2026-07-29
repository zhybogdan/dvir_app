import 'package:dvir/core/utils/list_reorder.dart';
import 'package:flutter_test/flutter_test.dart';

// Two lines with an off-by-one in the middle, and a wrong one does not throw —
// it puts a dragged row one place away from where it was dropped, which reads
// as the app arguing with the finger that moved it.
void main() {
  const items = ['a', 'b', 'c', 'd'];

  test('a row moves down to the place it was dropped on', () {
    expect(reordered(items, from: 0, to: 2), ['b', 'c', 'a', 'd']);
  });

  test('and up the same way', () {
    expect(reordered(items, from: 3, to: 1), ['a', 'd', 'b', 'c']);
  });

  test('the ends are reachable from either direction', () {
    expect(reordered(items, from: 0, to: 3), ['b', 'c', 'd', 'a']);
    expect(reordered(items, from: 3, to: 0), ['d', 'a', 'b', 'c']);
  });

  test('a row dropped where it already was changes nothing', () {
    expect(reordered(items, from: 1, to: 1), items);
  });

  // The list a drag started from is rendered while the new one is being saved,
  // so the two must not be the same object.
  test('the original is left alone', () {
    final original = [...items];

    reordered(original, from: 0, to: 2);

    expect(original, items);
  });
}
