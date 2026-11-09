// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_manifest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BackupManifest _$BackupManifestFromJson(Map<String, dynamic> json) =>
    _BackupManifest(
      formatVersion: (json['format_version'] as num).toInt(),
      schemaVersion: (json['schema_version'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      appVersion: json['app_version'] as String,
      units: (json['units'] as num).toInt(),
      attributes: (json['attributes'] as num).toInt(),
      documents: (json['documents'] as num).toInt(),
      contacts: (json['contacts'] as num).toInt(),
    );

Map<String, dynamic> _$BackupManifestToJson(_BackupManifest instance) =>
    <String, dynamic>{
      'format_version': instance.formatVersion,
      'schema_version': instance.schemaVersion,
      'created_at': instance.createdAt.toIso8601String(),
      'app_version': instance.appVersion,
      'units': instance.units,
      'attributes': instance.attributes,
      'documents': instance.documents,
      'contacts': instance.contacts,
    };
