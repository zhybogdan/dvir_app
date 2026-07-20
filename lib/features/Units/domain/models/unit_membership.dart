import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit_membership.freezed.dart';
part 'unit_membership.g.dart';

/// One person's place in one object — the counterpart of
/// `CommunityMembership`, and read by the router for the same purpose.
@freezed
abstract class UnitMembership with _$UnitMembership {
  const factory UnitMembership({
    required String id,
    @JsonKey(name: 'unit_id') required String unitId,
    @JsonKey(name: 'user_id') required String userId,
    required UnitRole role,
    required MemberStatus status,
  }) = _UnitMembership;

  factory UnitMembership.fromJson(Map<String, dynamic> json) =>
      _$UnitMembershipFromJson(json);
}
