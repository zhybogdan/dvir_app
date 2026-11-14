import 'package:dvir/features/Home/domain/models/scope_summary.dart';

/// One line of the home list: a scope, and the objects of the user's own that
/// sit inside it.
///
/// [nested] holds whole summaries rather than bare objects because a nested
/// object is drawn as a card of its own now, and a card shows how much the
/// place holds.
typedef ScopeRow = ({ScopeSummary scope, List<UnitSummary> nested});

/// Turns the flat membership list into what the home screen shows.
///
/// Creating a flat inside a house makes the caller its owner, so both arrive in
/// the same list and the house's own flats would otherwise stand beside it as
/// separate places to live. The rule is not "hide anything with a parent",
/// which would lose a tenant's only object: a flat is folded away **only when
/// its parent is a scope of this user's too**. A tenant let into one flat does
/// not belong to the house, so their flat stays where they can reach it.
///
/// [nested] is what the parent card draws underneath itself, indented. It
/// lists the user's own objects rather than every child — the home screen
/// answers "where do I belong", and the object's own screen is where the full
/// contents live.
List<ScopeRow> arrangeScopes(List<ScopeSummary> scopes) {
  // Written out rather than built as a collection-for: the key comes from the
  // object and the value is the summary around it, and one comprehension
  // cannot bind both.
  final mine = <String, UnitSummary>{};
  for (final scope in scopes) {
    if (scope is! UnitSummary) continue;
    final unit = scope.unit;
    if (unit != null) mine[unit.id] = scope;
  }

  final childrenOf = <String, List<UnitSummary>>{};
  for (final summary in mine.values) {
    final parentId = summary.unit?.parentId;
    if (parentId != null && mine.containsKey(parentId)) {
      childrenOf.putIfAbsent(parentId, () => []).add(summary);
    }
  }

  return [
    for (final scope in scopes)
      if (!_isFolded(scope, mine))
        (
          scope: scope,
          nested: switch (scope) {
            UnitSummary(:final unit?) => childrenOf[unit.id] ?? const [],
            _ => const <UnitSummary>[],
          },
        ),
  ];
}

bool _isFolded(ScopeSummary scope, Map<String, UnitSummary> mine) =>
    switch (scope) {
      UnitSummary(:final unit?) =>
        unit.parentId != null && mine.containsKey(unit.parentId),
      _ => false,
    };
