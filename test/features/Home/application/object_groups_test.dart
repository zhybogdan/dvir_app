import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Home/application/object_groups.dart';
import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// The papers and phones tabs are one list made of several. What is pinned here
// is how the parts combine: an object with nothing in it drops out, the order
// is the order of the objects, a scope still waiting holds nothing to show, and
// one failed or unfinished part makes the whole answer failed or unfinished —
// never a tab that silently shows two objects of three.

ScopeSummary _unit(String id, {MemberStatus status = MemberStatus.active}) =>
    ScopeSummary.unit(
      membership: UnitMembership(
        id: 'um-$id',
        unitId: id,
        userId: 'me',
        role: UnitRole.owner,
        status: status,
      ),
      unit: Unit(id: id, label: id, type: UnitType.house),
    );

AsyncValue<MyScopes?> _scopes(List<ScopeSummary> scopes) =>
    AsyncData((userId: 'me', scopes: scopes));

void main() {
  test('one group per object that holds something, in the order listed', () {
    final lists = <String, AsyncValue<List<String>>>{
      'a': const AsyncData(['a1', 'a2']),
      'b': const AsyncData([]),
      'c': const AsyncData(['c1']),
    };

    final result = groupByObject<String>(
      _scopes([_unit('a'), _unit('b'), _unit('c')]),
      (scope) => lists[scope.id] ?? const AsyncData([]),
    );

    final groups = result.value ?? const [];
    expect(groups.map((group) => group.unit.id), ['a', 'c']);
    expect(groups.first.items, ['a1', 'a2']);
  });

  // RLS withholds a pending object's rows, so asking for its list would be a
  // question with no answer — it is not asked at all.
  test('a scope still waiting for approval is not asked', () {
    final asked = <String>[];

    groupByObject<String>(
      _scopes([_unit('a'), _unit('p', status: MemberStatus.pending)]),
      (scope) {
        asked.add(scope.id);
        return const AsyncData(['x']);
      },
    );

    expect(asked, ['a']);
  });

  test('one list still loading keeps the whole answer loading', () {
    final result = groupByObject<String>(
      _scopes([_unit('a'), _unit('b')]),
      (scope) => scope == const ScopeRef.unit('a')
          ? const AsyncData(['a1'])
          : const AsyncLoading(),
    );

    expect(result, isA<AsyncLoading<List<ObjectGroup<String>>>>());
  });

  test('one list that failed fails the whole answer', () {
    final result = groupByObject<String>(
      _scopes([_unit('a'), _unit('b')]),
      (scope) => scope == const ScopeRef.unit('a')
          ? const AsyncData(['a1'])
          : AsyncError<List<String>>(StateError('offline'), StackTrace.empty),
    );

    expect(result.hasError, isTrue);
  });

  test('the list of objects still loading means nothing is asked yet', () {
    var asked = false;

    final result = groupByObject<String>(const AsyncLoading(), (scope) {
      asked = true;
      return const AsyncData([]);
    });

    expect(result, isA<AsyncLoading<List<ObjectGroup<String>>>>());
    expect(asked, isFalse);
  });
}
