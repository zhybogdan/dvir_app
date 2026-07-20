// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommunityMembership _$CommunityMembershipFromJson(Map<String, dynamic> json) =>
    _CommunityMembership(
      id: json['id'] as String,
      communityId: json['community_id'] as String,
      userId: json['user_id'] as String,
      role: $enumDecode(_$MemberRoleEnumMap, json['role']),
      status: $enumDecode(_$MemberStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$CommunityMembershipToJson(
  _CommunityMembership instance,
) => <String, dynamic>{
  'id': instance.id,
  'community_id': instance.communityId,
  'user_id': instance.userId,
  'role': _$MemberRoleEnumMap[instance.role]!,
  'status': _$MemberStatusEnumMap[instance.status]!,
};

const _$MemberRoleEnumMap = {
  MemberRole.admin: 'admin',
  MemberRole.member: 'member',
  MemberRole.accountant: 'accountant',
  MemberRole.worker: 'worker',
};

const _$MemberStatusEnumMap = {
  MemberStatus.pending: 'pending',
  MemberStatus.active: 'active',
  MemberStatus.rejected: 'rejected',
  MemberStatus.blocked: 'blocked',
};
