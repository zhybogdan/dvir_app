import 'package:dvir/features/Community/domain/models/community.dart';
import 'package:dvir/features/Community/domain/models/community_membership.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scope_summary.freezed.dart';

/// How much an object holds — what the card on the home screen shows beside
/// its name.
///
/// Counted by the database rather than by loading the lists: the home screen
/// answers for every object at once, and `.length` of a list it does not
/// otherwise need would be several full reads per card.
///
/// Objects nested inside this one are **not** here. `arrangeScopes` already
/// knows them by name, so a third number asked of the database would be one
/// the app has in hand.
typedef ScopeCounts = ({int documents, int attributes});

/// One line of "where I belong": the membership, and the scope behind it.
///
/// [CommunitySummary.community] and [UnitSummary.unit] are nullable because RLS
/// hides a scope from anyone who is not yet an active member — including its
/// name. That is deliberate rather than an oversight: an invite code must not
/// let a stranger find out what stands behind it. So a scope still waiting for
/// approval has a status and nothing else to show.
///
/// Sealed, so a screen that renders communities and forgets objects does not
/// compile.
@freezed
sealed class ScopeSummary with _$ScopeSummary {
  const ScopeSummary._();

  const factory ScopeSummary.community({
    required CommunityMembership membership,
    Community? community,
  }) = CommunitySummary;

  /// [counts] is null rather than zero wherever the contents are unknown: a
  /// scope still waiting for approval has nothing readable behind it, and a
  /// card shows no numbers instead of claiming the place is empty.
  const factory ScopeSummary.unit({
    required UnitMembership membership,
    Unit? unit,
    ScopeCounts? counts,
  }) = UnitSummary;

  /// Approval state regardless of scope — what the router asks, and what
  /// decides whether this row is openable.
  MemberStatus get status => switch (this) {
    CommunitySummary(:final membership) => membership.status,
    UnitSummary(:final membership) => membership.status,
  };

  bool get isActive => status == MemberStatus.active;
}
