import 'package:dvir/features/Community/domain/models/community.dart';
import 'package:dvir/features/Community/domain/models/community_membership.dart';
import 'package:dvir/features/Community/domain/types/community_type.dart';
import 'package:dvir/features/Community/domain/types/member_role.dart';
import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:dvir/features/Home/domain/scope_arrangement.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:flutter_test/flutter_test.dart';

ScopeSummary _unit(
  String id, {
  String? parentId,
  UnitRole role = UnitRole.owner,
  MemberStatus status = MemberStatus.active,
}) => ScopeSummary.unit(
  membership: UnitMembership(
    id: 'um-$id',
    unitId: id,
    userId: 'me',
    role: role,
    status: status,
  ),
  unit: Unit(id: id, label: id, type: UnitType.apartment, parentId: parentId),
);

/// A scope still waiting for approval: RLS withholds the object itself, so the
/// row carries a membership and nothing to nest by.
ScopeSummary _pendingUnit(String id) => ScopeSummary.unit(
  membership: UnitMembership(
    id: 'um-$id',
    unitId: id,
    userId: 'me',
    role: UnitRole.family,
    status: MemberStatus.pending,
  ),
);

ScopeSummary _community(String id) => ScopeSummary.community(
  membership: CommunityMembership(
    id: 'cm-$id',
    communityId: id,
    userId: 'me',
    role: MemberRole.member,
    status: MemberStatus.active,
  ),
  community: Community(
    id: id,
    name: id,
    type: CommunityType.osbb,
    inviteCode: 'CODE1234',
  ),
);

void main() {
  test('leaves a standalone object alone', () {
    final rows = arrangeScopes([_unit('house')]);

    expect(rows, hasLength(1));
    expect(rows.single.nested, isEmpty);
  });

  test('folds a flat into the house it belongs to', () {
    final rows = arrangeScopes([
      _unit('house'),
      _unit('flat-1', parentId: 'house'),
      _unit('flat-2', parentId: 'house'),
    ]);

    expect(rows, hasLength(1), reason: 'only the house stays on top');
    expect(
      rows.single.nested.map((unit) => unit.id),
      ['flat-1', 'flat-2'],
      reason: 'and it names what of mine is inside it',
    );
  });

  // The case a plain "hide anything with a parent" rule would break: a tenant
  // belongs to the flat but not to the house around it, and hiding the flat
  // would leave them with an empty home screen.
  test('keeps a flat whose house is not the user\'s', () {
    final rows = arrangeScopes([_unit('flat-1', parentId: 'house')]);

    expect(rows, hasLength(1));
    expect(rows.single.nested, isEmpty);
  });

  test('never folds a scope still waiting for approval', () {
    final rows = arrangeScopes([_unit('house'), _pendingUnit('flat-1')]);

    expect(rows, hasLength(2));
  });

  test('leaves communities where they are', () {
    final rows = arrangeScopes([_community('c1'), _unit('house')]);

    expect(rows.map((row) => row.scope), [
      isA<CommunitySummary>(),
      isA<UnitSummary>(),
    ]);
  });

  test('keeps the order the scopes arrived in', () {
    final rows = arrangeScopes([
      _unit('house-a'),
      _unit('house-b'),
      _unit('flat', parentId: 'house-a'),
    ]);

    expect(rows.map((row) => row.scope).whereType<UnitSummary>().length, 2);
    expect(rows.map((row) => (row.scope as UnitSummary).unit?.id), [
      'house-a',
      'house-b',
    ]);
  });
}
