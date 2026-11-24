import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup_manifest.freezed.dart';
part 'backup_manifest.g.dart';

/// What an archive says about itself, read before anything inside it is used.
///
/// Restoring replaces everything the phone holds, so this exists to be shown
/// to the person first — when the copy was made and how much is in it — and to
/// refuse a file that is not ours before a single row is touched.
@freezed
abstract class BackupManifest with _$BackupManifest {
  const factory BackupManifest({
    @JsonKey(name: 'format_version') required int formatVersion,
    @JsonKey(name: 'schema_version') required int schemaVersion,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'app_version') required String appVersion,
    required int units,
    required int attributes,
    required int documents,
    required int contacts,
  }) = _BackupManifest;

  factory BackupManifest.fromJson(Map<String, dynamic> json) =>
      _$BackupManifestFromJson(json);
}

/// The shape of the archive, not of the data inside it: which parts it holds
/// and what they are called. Raised only when an older build could no longer
/// make sense of what a newer one writes.
const int backupFormatVersion = 1;
