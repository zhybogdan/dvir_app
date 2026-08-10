import 'package:dvir/core/config/local_identity.dart';
import 'package:dvir/features/Members/data/members_repository_local.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const repository = LocalMembersRepository();

  test('the household is one person, and they own it', () async {
    final members = await repository.unitMembers('unit');

    final only = members.single;

    // What `myUnitRole` reads to decide whether the hub offers anything at all:
    // answer "nobody" here and the keeper of the house cannot add a paper to it.
    expect(only.membership.userId, localUserId);
    expect(only.membership.role, UnitRole.owner);
    expect(only.membership.status, MemberStatus.active);
    expect(only.isActive, isTrue);
  });

  test('the person belongs to the object that was asked about', () async {
    final members = await repository.unitMembers('some-other-unit');

    expect(members.single.membership.unitId, 'some-other-unit');
  });

  test('there is nobody to moderate, and saying so is the answer', () async {
    expect(
      () => repository.setUnitMemberRole(
        memberId: 'anyone',
        role: UnitRole.tenant,
      ),
      throwsUnsupportedError,
    );
    expect(() => repository.removeUnitMember('anyone'), throwsUnsupportedError);
    expect(() => repository.communityMembers('any'), throwsUnsupportedError);
  });
}
