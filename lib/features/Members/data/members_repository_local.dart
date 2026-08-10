import 'package:dvir/core/config/local_identity.dart';
import 'package:dvir/features/Community/domain/types/member_role.dart';
import 'package:dvir/features/Members/data/members_repository.dart';
import 'package:dvir/features/Members/domain/models/community_member_view.dart';
import 'package:dvir/features/Members/domain/models/unit_member_view.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';

/// The people of an object when there is only ever one (Impl).
///
/// Nothing is stored: there is no `unit_members` table on the device, because a
/// household of one has nothing to record. The single row is invented on the
/// spot, and every field of it is true — this person is the owner, and they are
/// active.
///
/// Inventing it is not cosmetic. `myUnitRole` reads this list to decide what the
/// hub offers, so a repository answering "nobody" would leave the keeper of the
/// house unable to add a document to it.
///
/// Moderation refuses outright. There is no second person to approve, reject or
/// remove, and the screens offering it are the next thing to go.
class LocalMembersRepository implements MembersRepository {
  const LocalMembersRepository();

  @override
  Future<List<UnitMemberView>> unitMembers(String unitId) async => [
    UnitMemberView(
      membership: UnitMembership(
        id: unitId,
        unitId: unitId,
        userId: localUserId,
        role: UnitRole.owner,
        status: MemberStatus.active,
      ),
    ),
  ];

  @override
  Future<List<CommunityMemberView>> communityMembers(String communityId) =>
      throw UnsupportedError('This build has no communities.');

  @override
  Future<void> setCommunityMemberStatus({
    required String memberId,
    required MemberStatus status,
  }) => throw UnsupportedError('This build has no communities.');

  @override
  Future<void> setCommunityMemberRole({
    required String memberId,
    required MemberRole role,
  }) => throw UnsupportedError('This build has no communities.');

  @override
  Future<void> setUnitMemberStatus({
    required String memberId,
    required MemberStatus status,
  }) => throw UnsupportedError('This build has nobody to moderate.');

  @override
  Future<void> setUnitMemberRole({
    required String memberId,
    required UnitRole role,
  }) => throw UnsupportedError('This build has nobody to moderate.');

  @override
  Future<void> removeCommunityMember(String memberId) =>
      throw UnsupportedError('This build has no communities.');

  @override
  Future<void> removeUnitMember(String memberId) =>
      throw UnsupportedError('This build has nobody to remove.');
}
