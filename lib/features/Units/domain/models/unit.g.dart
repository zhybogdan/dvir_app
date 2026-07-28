// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Unit _$UnitFromJson(Map<String, dynamic> json) => _Unit(
  id: json['id'] as String,
  label: json['label'] as String,
  type: $enumDecode(_$UnitTypeEnumMap, json['type']),
  inviteCode: json['invite_code'] as String?,
  communityId: json['community_id'] as String?,
  parentId: json['parent_id'] as String?,
  address: json['address'] as String?,
  city: json['city'] as String?,
  areaM2: (json['area_m2'] as num?)?.toDouble(),
);

Map<String, dynamic> _$UnitToJson(_Unit instance) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'type': _$UnitTypeEnumMap[instance.type]!,
  'invite_code': instance.inviteCode,
  'community_id': instance.communityId,
  'parent_id': instance.parentId,
  'address': instance.address,
  'city': instance.city,
  'area_m2': instance.areaM2,
};

const _$UnitTypeEnumMap = {
  UnitType.house: 'house',
  UnitType.apartment: 'apartment',
  UnitType.plot: 'plot',
  UnitType.room: 'room',
  UnitType.bathroom: 'bathroom',
  UnitType.corridor: 'corridor',
  UnitType.storeroom: 'storeroom',
  UnitType.balcony: 'balcony',
  UnitType.loggia: 'loggia',
  UnitType.basement: 'basement',
  UnitType.garage: 'garage',
  UnitType.summerKitchen: 'summer_kitchen',
  UnitType.summerHouse: 'summer_house',
  UnitType.shed: 'shed',
  UnitType.pool: 'pool',
  UnitType.office: 'office',
  UnitType.custom: 'custom',
};
