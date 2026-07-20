// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UnitMembership _$UnitMembershipFromJson(Map<String, dynamic> json) =>
    _UnitMembership(
      id: json['id'] as String,
      unitId: json['unit_id'] as String,
      userId: json['user_id'] as String,
      role: $enumDecode(_$UnitRoleEnumMap, json['role']),
      status: $enumDecode(_$MemberStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$UnitMembershipToJson(_UnitMembership instance) =>
    <String, dynamic>{
      'id': instance.id,
      'unit_id': instance.unitId,
      'user_id': instance.userId,
      'role': _$UnitRoleEnumMap[instance.role]!,
      'status': _$MemberStatusEnumMap[instance.status]!,
    };

const _$UnitRoleEnumMap = {
  UnitRole.owner: 'owner',
  UnitRole.family: 'family',
  UnitRole.tenant: 'tenant',
};

const _$MemberStatusEnumMap = {
  MemberStatus.pending: 'pending',
  MemberStatus.active: 'active',
  MemberStatus.rejected: 'rejected',
  MemberStatus.blocked: 'blocked',
};
