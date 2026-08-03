// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Document _$DocumentFromJson(Map<String, dynamic> json) => _Document(
  id: json['id'] as String,
  title: json['title'] as String,
  storagePath: json['storage_path'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  mimeType: json['mime_type'] as String?,
  sizeBytes: (json['size_bytes'] as num?)?.toInt(),
  originalName: json['original_name'] as String?,
);

Map<String, dynamic> _$DocumentToJson(_Document instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'storage_path': instance.storagePath,
  'created_at': instance.createdAt.toIso8601String(),
  'mime_type': instance.mimeType,
  'size_bytes': instance.sizeBytes,
  'original_name': instance.originalName,
};
