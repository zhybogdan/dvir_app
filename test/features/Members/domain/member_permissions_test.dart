import 'package:dvir/features/Community/domain/models/community_membership.dart';
import 'package:dvir/features/Community/domain/types/member_role.dart';
import 'package:dvir/features/Members/domain/member_permissions.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:flutter_test/flutter_test.dart';

// These rules also live in SQL, where they are enforced. What is checked here
// is that the UI predicts the same answer — a menu item that stays enabled on a
// call the database will refuse turns a rule into an error toast.
void main() {
  const myUserId = 'me';

  CommunityMembership admin(
    String userId, {
    MemberStatus status = MemberStatus.active,
  }) => CommunityMembership(
    id: 'cm-$userId',
    communityId: 'c1',
    userId: userId,
    role: MemberRole.admin,
    status: status,
  );

  CommunityMembership member(
    String userId, {
    MemberStatus status = MemberStatus.active,
  }) => CommunityMembership(
    id: 'cm-$userId',
    communityId: 'c1',
    userId: userId,
    role: MemberRole.member,
    status: status,
  );

  UnitMembership owner(String userId) => UnitMembership(
    id: 'um-$userId',
    unitId: 'u1',
    userId: userId,
    role: UnitRole.owner,
    status: MemberStatus.active,
  );

  UnitMembership tenant(String userId) => UnitMembership(
    id: 'um-$userId',
    unitId: 'u1',
    userId: userId,
    role: UnitRole.tenant,
    status: MemberStatus.active,
  );

  group('status', () {
    test('cannot be changed on yourself', () {
      final me = admin(myUserId);

      final actions = communityMemberActions(
        member: me,
        all: [
          me,
          member('other', status: MemberStatus.pending),
        ],
        myUserId: myUserId,
      );

      expect(actions.canChangeStatus, isFalse);
    });

    test('can be changed on somebody else', () {
      final applicant = member('other', status: MemberStatus.pending);

      final actions = communityMemberActions(
        member: applicant,
        all: [admin(myUserId), applicant],
        myUserId: myUserId,
      );

      expect(actions.canChangeStatus, isTrue);
    });
  });

  group('role', () {
    test('cannot be given away by the last admin', () {
      final me = admin(myUserId);

      final actions = communityMemberActions(
        member: me,
        all: [me, member('other')],
        myUserId: myUserId,
      );

      expect(actions.canChangeRole, isFalse);
    });

    test('can be given away once a second admin exists', () {
      final me = admin(myUserId);

      final actions = communityMemberActions(
        member: me,
        all: [me, admin('other')],
        myUserId: myUserId,
      );

      expect(actions.canChangeRole, isTrue);
    });

    // A pending or blocked admin cannot run anything, so they do not hold the
    // last-admin seat for someone else.
    test('counts only active admins as running the community', () {
      final me = admin(myUserId);

      final actions = communityMemberActions(
        member: me,
        all: [
          me,
          admin('other', status: MemberStatus.pending),
        ],
        myUserId: myUserId,
      );

      expect(actions.canChangeRole, isFalse);
    });

    test('is free to change on somebody else', () {
      final other = member('other');

      final actions = communityMemberActions(
        member: other,
        all: [admin(myUserId), other],
        myUserId: myUserId,
      );

      expect(actions.canChangeRole, isTrue);
    });

    test('is free to change when you are not a runner yourself', () {
      final me = member(myUserId);

      final actions = communityMemberActions(
        member: me,
        all: [me, admin('other')],
        myUserId: myUserId,
      );

      expect(actions.canChangeRole, isTrue);
    });
  });

  group('objects follow the same rules through ownership', () {
    test('the last owner keeps the role', () {
      final me = owner(myUserId);

      final actions = unitMemberActions(
        member: me,
        all: [me, tenant('other')],
        myUserId: myUserId,
      );

      expect(actions.canChangeRole, isFalse);
      expect(actions.canChangeStatus, isFalse);
    });

    test('a second owner frees the first', () {
      final me = owner(myUserId);

      final actions = unitMemberActions(
        member: me,
        all: [me, owner('other')],
        myUserId: myUserId,
      );

      expect(actions.canChangeRole, isTrue);
    });
  });
}
