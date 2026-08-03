import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_scope.freezed.dart';

/// Which scope a file hangs off — one object, or one community.
///
/// `documents` carries `community_id` and `unit_id` with exactly one of them
/// set (`0010`), so an id on its own never says enough to read or write a row:
/// the column has to travel with it. A bare string would leave every call site
/// repeating which half it meant.
///
/// It is also what lets the community product reuse this feature untouched —
/// only the household has screens today, but nothing under them assumes that.
@freezed
sealed class DocumentScope with _$DocumentScope {
  const DocumentScope._();

  const factory DocumentScope.unit(String id) = UnitDocuments;
  const factory DocumentScope.community(String id) = CommunityDocuments;

  /// The column this id belongs in — what a read filters by and a write sets.
  String get column => switch (this) {
    UnitDocuments() => 'unit_id',
    CommunityDocuments() => 'community_id',
  };
}
