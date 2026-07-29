/// [items] with the entry at [from] moved to [to], leaving the original alone.
///
/// Two lines with an off-by-one in the middle of them, which is why they are
/// here and tested rather than inlined into a callback: `insert` places the
/// item *before* the index it is given, and the index a drag reports is counted
/// against the list the item has already left.
List<T> reordered<T>(List<T> items, {required int from, required int to}) {
  final copy = [...items];
  final item = copy.removeAt(from);
  copy.insert(to, item);

  return copy;
}
