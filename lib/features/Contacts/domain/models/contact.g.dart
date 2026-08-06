// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Contact _$ContactFromJson(Map<String, dynamic> json) => _Contact(
  id: json['id'] as String,
  name: json['name'] as String,
  role: json['role'] as String?,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$ContactToJson(_Contact instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'role': instance.role,
  'phone': instance.phone,
};
