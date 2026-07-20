import 'package:dvir/features/Community/domain/models/community_membership.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_result.freezed.dart';

/// What an invite code turned out to open.
///
/// One code field, either scope: the user cannot say which kind of code they
/// hold — the app has no way to know, and asking would leak what the code
/// opens. The backend resolves it and says which branch it took.
@freezed
sealed class JoinResult with _$JoinResult {
  const factory JoinResult.community(CommunityMembership membership) =
      JoinedCommunity;

  const factory JoinResult.unit(UnitMembership membership) = JoinedUnit;
}
