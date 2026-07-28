import 'package:dvir/features/Community/domain/models/community_membership.dart';
import 'package:dvir/features/Community/domain/types/member_role.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';

/// What the signed-in moderator may do to one row of a members list.
typedef MemberActions = ({bool canChangeStatus, bool canChangeRole});

/// The two moderation rules, in one place.
///
/// The database is what actually enforces them — `0004_members_moderation.sql`
/// answers DV005 for the first and DV004 for the second. This copy exists so a
/// menu item can be greyed out, and the user learns the rule before tapping
/// rather than from an error toast.
///
/// [isRunner] means the row belongs to someone who can run the scope: an active
/// admin of a community, or an active owner of an object. [runnerCount] counts
/// how many such people the scope has in total.
MemberActions memberActions({
  required String memberUserId,
  required String myUserId,
  required bool isRunner,
  required int runnerCount,
}) {
  final isSelf = memberUserId == myUserId;

  return (
    // Approving, rejecting or blocking yourself is never allowed — someone has
    // to be on the other side of that decision.
    canChangeStatus: !isSelf,

    // Handing your own role away is fine: a chairperson passing the community
    // on stops being an admin. Being the last one able to run the scope is
    // what stops it.
    //
    // The mirror case — demoting *somebody else* who turns out to be the last
    // runner — cannot arise. Whoever is moderating is a runner themselves, so
    // any other active runner in the list makes at least two.
    canChangeRole: !(isSelf && isRunner && runnerCount <= 1),
  );
}

/// [memberActions] for a community, where running the scope means being an
/// active admin.
MemberActions communityMemberActions({
  required CommunityMembership member,
  required Iterable<CommunityMembership> all,
  required String myUserId,
}) => memberActions(
  memberUserId: member.userId,
  myUserId: myUserId,
  isRunner: _isAdmin(member),
  runnerCount: all.where(_isAdmin).length,
);

/// [memberActions] for an object, where running the scope means being an active
/// owner.
MemberActions unitMemberActions({
  required UnitMembership member,
  required Iterable<UnitMembership> all,
  required String myUserId,
}) => memberActions(
  memberUserId: member.userId,
  myUserId: myUserId,
  isRunner: _isOwner(member),
  runnerCount: all.where(_isOwner).length,
);

bool _isAdmin(CommunityMembership member) =>
    member.role == MemberRole.admin && member.status == MemberStatus.active;

bool _isOwner(UnitMembership member) =>
    member.role == UnitRole.owner && member.status == MemberStatus.active;
