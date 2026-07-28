import 'package:dvir/features/Community/domain/types/member_role.dart';
import 'package:dvir/features/Members/domain/models/community_member_view.dart';
import 'package:dvir/features/Members/domain/models/unit_member_view.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';

/// Contract for reading and moderating the people of a scope (Base).
///
/// One repository for both scopes, because they are one mechanism: the tables
/// mirror each other by design (`0002_units_as_scopes.sql`), the statuses are
/// literally the same enum, and the screens differ only in which set of roles
/// they offer.
abstract interface class MembersRepository {
  Future<List<CommunityMemberView>> communityMembers(String communityId);

  Future<List<UnitMemberView>> unitMembers(String unitId);

  /// Approves, rejects or blocks a join request.
  ///
  /// Goes through an RPC rather than an update: the rule that nobody decides on
  /// their own request lives there, next to the last-admin guard.
  Future<void> setCommunityMemberStatus({
    required String memberId,
    required MemberStatus status,
  });

  Future<void> setCommunityMemberRole({
    required String memberId,
    required MemberRole role,
  });

  Future<void> setUnitMemberStatus({
    required String memberId,
    required MemberStatus status,
  });

  Future<void> setUnitMemberRole({
    required String memberId,
    required UnitRole role,
  });

  /// Removes someone from the community entirely, rather than blocking them.
  Future<void> removeCommunityMember(String memberId);

  Future<void> removeUnitMember(String memberId);
}
