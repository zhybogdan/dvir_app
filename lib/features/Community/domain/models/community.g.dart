// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Community _$CommunityFromJson(Map<String, dynamic> json) => _Community(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$CommunityTypeEnumMap, json['type']),
  inviteCode: json['invite_code'] as String,
  address: json['address'] as String?,
  city: json['city'] as String?,
);

Map<String, dynamic> _$CommunityToJson(_Community instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$CommunityTypeEnumMap[instance.type]!,
      'invite_code': instance.inviteCode,
      'address': instance.address,
      'city': instance.city,
    };

const _$CommunityTypeEnumMap = {
  CommunityType.osbb: 'osbb',
  CommunityType.residentialComplex: 'residential_complex',
  CommunityType.dachaCooperative: 'dacha_cooperative',
  CommunityType.garageCooperative: 'garage_cooperative',
  CommunityType.cottageTown: 'cottage_town',
  CommunityType.dormitory: 'dormitory',
  CommunityType.custom: 'custom',
};
