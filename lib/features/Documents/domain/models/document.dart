import 'package:freezed_annotation/freezed_annotation.dart';

part 'document.freezed.dart';
part 'document.g.dart';

/// One file kept against a scope — a scan of the техпаспорт, a contract, a
/// photo of the meter cabinet.
///
/// Neither scope id is here, for the reason `UnitAttribute` leaves out its own:
/// a list is always read for one scope, so the scope is what the caller already
/// holds.
///
/// `category` is absent although the column exists: whether it is a fixed list
/// or whatever the keeper types is open until the section has real rows in it,
/// and a field nothing reads is dead weight.
///
/// The three file columns are nullable because the row may predate them —
/// `0010` added them to a table that already existed.
@freezed
abstract class Document with _$Document {
  const factory Document({
    required String id,
    required String title,
    @JsonKey(name: 'storage_path') required String storagePath,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'mime_type') String? mimeType,
    @JsonKey(name: 'size_bytes') int? sizeBytes,
    @JsonKey(name: 'original_name') String? originalName,
  }) = _Document;

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);
}
