import 'package:dvir/features/Community/domain/types/member_role.dart';
import 'package:dvir/features/Community/domain/types/member_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_membership.freezed.dart';
part 'community_membership.g.dart';

/// One user's place in one community — the row the router reads to decide
/// between onboarding, the waiting screen and the app itself.
@freezed
abstract class CommunityMembership with _$CommunityMembership {
  const factory CommunityMembership({
    required String id,
    @JsonKey(name: 'community_id') required String communityId,
    @JsonKey(name: 'user_id') required String userId,
    required MemberRole role,
    required MemberStatus status,
  }) = _CommunityMembership;

  factory CommunityMembership.fromJson(Map<String, dynamic> json) =>
      _$CommunityMembershipFromJson(json);
}
