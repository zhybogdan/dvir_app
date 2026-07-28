import 'package:dvir/features/Community/domain/models/community_membership.dart';
import 'package:dvir/features/Shared/domain/models/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_member_view.freezed.dart';

/// One row of a community members list: the membership, plus the person it
/// belongs to.
///
/// [profile] is nullable because the embed genuinely comes back empty for some
/// readers. A plain member sees every row of their community — including people
/// still waiting to be let in — but is allowed to read the profile only of
/// those already active. An admin, who is the one deciding on those requests,
/// sees them all.
///
/// No `fromJson`: the row carries the membership columns flat and the profile
/// nested, so the repository assembles the two halves.
@freezed
abstract class CommunityMemberView with _$CommunityMemberView {
  const factory CommunityMemberView({
    required CommunityMembership membership,
    Profile? profile,
  }) = _CommunityMemberView;
}
