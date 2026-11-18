import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// One object, and what it keeps of one kind — its papers, or its phones.
typedef ObjectGroup<T> = ({Unit unit, List<T> items});

/// Everything of one kind across every object this person belongs to, one
/// group per object, in the order the objects are listed.
///
/// Composed from the per-object lists that already exist rather than read
/// with a query of its own: a household has a handful of objects, each list
/// is already cached for the object's own screen, and a cross-object read
/// would have meant a second method on two repositories and a unit id the
/// document and contact models deliberately do not carry.
///
/// Only objects that can be opened: a scope still waiting for approval has
/// nothing readable behind it. Groups with nothing in them are left out — a
/// tab of headings over empty space says less than a shorter tab.
///
/// The answer is loading while anything it is made of is loading, and failed
/// if anything failed: a tab that showed two objects' papers and silently
/// dropped the third would be the worst of the three.
AsyncValue<List<ObjectGroup<T>>> groupByObject<T>(
  AsyncValue<MyScopes?> scopes,
  AsyncValue<List<T>> Function(ScopeRef scope) itemsOf,
) {
  if (scopes.hasError) {
    return AsyncError(
      scopes.error ?? StateError('scopes'),
      scopes.stackTrace ?? StackTrace.current,
    );
  }
  if (!scopes.hasValue) return const AsyncLoading();

  final units = <Unit>[
    for (final scope in scopes.value?.scopes ?? const <ScopeSummary>[])
      if (scope case UnitSummary(:final unit?) when scope.isActive) unit,
  ];

  final lists = [for (final unit in units) itemsOf(ScopeRef.unit(unit.id))];

  for (final list in lists) {
    if (list.hasError) {
      return AsyncError(
        list.error ?? StateError('items'),
        list.stackTrace ?? StackTrace.current,
      );
    }
  }
  if (lists.any((list) => !list.hasValue)) return const AsyncLoading();

  return AsyncData([
    for (final (index, unit) in units.indexed)
      if (lists[index].value case final items? when items.isNotEmpty)
        (unit: unit, items: items),
  ]);
}
