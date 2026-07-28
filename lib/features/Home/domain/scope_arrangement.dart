import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';

/// One line of the home list: a scope, and the objects of the user's own that
/// sit inside it.
typedef ScopeRow = ({ScopeSummary scope, List<Unit> nested});

/// Turns the flat membership list into what the home screen shows.
///
/// Creating a flat inside a house makes the caller its owner, so both arrive in
/// the same list and the house's own flats would otherwise stand beside it as
/// separate places to live. The rule is not "hide anything with a parent",
/// which would lose a tenant's only object: a flat is folded away **only when
/// its parent is a scope of this user's too**. A tenant let into one flat does
/// not belong to the house, so their flat stays where they can reach it.
///
/// [nested] is what the parent card names in small print. It lists the user's
/// own objects rather than every child — the home screen answers "where do I
/// belong", and the object's own screen is where the full contents live.
List<ScopeRow> arrangeScopes(List<ScopeSummary> scopes) {
  final mine = <String, Unit>{
    for (final scope in scopes)
      if (scope case UnitSummary(:final unit?)) unit.id: unit,
  };

  final childrenOf = <String, List<Unit>>{};
  for (final unit in mine.values) {
    final parentId = unit.parentId;
    if (parentId != null && mine.containsKey(parentId)) {
      childrenOf.putIfAbsent(parentId, () => []).add(unit);
    }
  }

  return [
    for (final scope in scopes)
      if (!_isFolded(scope, mine))
        (
          scope: scope,
          nested: switch (scope) {
            UnitSummary(:final unit?) => childrenOf[unit.id] ?? const [],
            _ => const <Unit>[],
          },
        ),
  ];
}

bool _isFolded(ScopeSummary scope, Map<String, Unit> mine) => switch (scope) {
  UnitSummary(:final unit?) =>
    unit.parentId != null && mine.containsKey(unit.parentId),
  _ => false,
};
