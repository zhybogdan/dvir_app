import 'package:freezed_annotation/freezed_annotation.dart';

part 'scope_ref.freezed.dart';

/// Which scope a row hangs off — one object, or one community.
///
/// Every table that serves both carries `community_id` and `unit_id` with
/// exactly one of them set (`0010`, `0011`), so an id on its own never says
/// enough to read or write a row: the column has to travel with it. A bare
/// string would leave every call site repeating which half it meant.
///
/// Shared rather than per-feature: documents were the first table shaped this
/// way, contacts are the second, and meters will be the third. It is also what
/// lets the community product reuse those features untouched — only the screens
/// differ, because only the screens know a household from a building.
@freezed
sealed class ScopeRef with _$ScopeRef {
  const ScopeRef._();

  const factory ScopeRef.unit(String id) = UnitScope;
  const factory ScopeRef.community(String id) = CommunityScope;

  /// The column this id belongs in — what a read filters by and a write sets.
  String get column => switch (this) {
    UnitScope() => 'unit_id',
    CommunityScope() => 'community_id',
  };
}
