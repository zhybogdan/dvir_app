import 'package:dvir/features/Community/domain/models/community_membership.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scope_membership.freezed.dart';

/// Where a person belongs — a community, or an object.
///
/// Serves two callers on purpose. It is what `join_by_invite` returns (one code
/// field, either scope: the user cannot say which kind of code they hold, and
/// asking would leak what the code opens), and it is what the router reads to
/// choose between onboarding, the waiting screen and the app itself. Both are
/// the same question with the same shape of answer.
///
/// Sealed, so a screen that handles one scope and forgets the other does not
/// compile.
@freezed
sealed class ScopeMembership with _$ScopeMembership {
  const ScopeMembership._();

  const factory ScopeMembership.community(CommunityMembership membership) =
      CommunityScope;

  const factory ScopeMembership.unit(UnitMembership membership) = UnitScope;

  /// Approval state regardless of scope — the only thing the router asks.
  MemberStatus get status => switch (this) {
    CommunityScope(:final membership) => membership.status,
    UnitScope(:final membership) => membership.status,
  };
}
